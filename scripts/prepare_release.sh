#!/usr/bin/env bash
# Prepares a release on the current feature/fix branch, following this repo's
# established convention: bump pubspec.yaml's version, optionally the pinned
# native-SDK dependency (Android and/or iOS) if this release exists to pick
# up a native SDK change, prepend a CHANGELOG.md entry (this repo's flat
# "## X.Y.Z" / plain bullets style — no brackets, no date, no category), and
# create the single combined commit release PRs have historically carried.
#
# This script does NOT tag, create the GitHub Release, or publish to pub.dev
# — per repo convention, that happens automatically once the PR merges to
# main (see .github/workflows/release.yml). Run this on your feature branch
# before opening the PR.
#
# IMPORTANT: --android-dep/--ios-dep only touch the dependency *pin* lines.
# They deliberately do NOT touch android/build.gradle's top-level `version
# '1.0'` or ios/ymchat_flutter.podspec's `s.version = '0.0.1'` — both are
# fixed placeholders unrelated to the package version (confirmed unchanged
# across this repo's entire release history) and must stay as-is.
#
# Usage:
#   scripts/prepare_release.sh --bump <patch|minor|major> \
#     [--android-dep vX.Y.Z] [--ios-dep X.Y.Z] "<bullet 1>" ["<bullet 2>" ...]
#   scripts/prepare_release.sh --version <X.Y.Z> ...
#
# Example:
#   scripts/prepare_release.sh --bump patch --ios-dep 2.4.1 \
#     "Upgraded native iOS SDK to pick up a WebView keyboard-resize fix."

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

PUBSPEC="pubspec.yaml"
ANDROID_GRADLE="android/build.gradle"
PODSPEC="ios/ymchat_flutter.podspec"
CHANGELOG="CHANGELOG.md"
INTEGRATION_BRANCH="main"

BUMP=""
NEW_VERSION=""
ANDROID_DEP=""
IOS_DEP=""
BULLETS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bump) BUMP="$2"; shift 2 ;;
    --version) NEW_VERSION="$2"; shift 2 ;;
    --android-dep) ANDROID_DEP="$2"; shift 2 ;;
    --ios-dep) IOS_DEP="$2"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) BULLETS+=("$1"); shift ;;
  esac
done

if [[ ${#BULLETS[@]} -eq 0 ]]; then
  echo "error: at least one changelog bullet is required" >&2
  exit 1
fi

if [[ -n "$BUMP" && -n "$NEW_VERSION" ]]; then
  echo "error: pass either --bump or --version, not both" >&2
  exit 1
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "$INTEGRATION_BRANCH" ]]; then
  echo "error: run this on a feature/fix branch, not $INTEGRATION_BRANCH (matches repo convention: the bump+changelog commit lives on the PR branch)" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: working tree is not clean; commit or stash your changes first" >&2
  exit 1
fi

CURRENT_VERSION="$(sed -n 's/^version:[[:space:]]*\([0-9][^[:space:]]*\).*/\1/p' "$PUBSPEC" | head -1)"
if [[ -z "$CURRENT_VERSION" ]]; then
  echo "error: could not read current version from $PUBSPEC" >&2
  exit 1
fi

if [[ -n "$BUMP" ]]; then
  IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
  case "$BUMP" in
    major) NEW_VERSION="$((MAJOR + 1)).0.0" ;;
    minor) NEW_VERSION="${MAJOR}.$((MINOR + 1)).0" ;;
    patch) NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))" ;;
    *) echo "error: --bump must be patch, minor, or major" >&2; exit 1 ;;
  esac
elif [[ -z "$NEW_VERSION" ]]; then
  echo "error: pass --bump <patch|minor|major> or --version <X.Y.Z>" >&2
  exit 1
fi

if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: version must look like X.Y.Z, got: $NEW_VERSION" >&2
  exit 1
fi

TAG="v${NEW_VERSION}"
if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
  echo "error: tag $TAG already exists" >&2
  exit 1
fi

echo "Bumping $CURRENT_VERSION -> $NEW_VERSION ($TAG)"

FILES_TO_COMMIT=("$PUBSPEC" "$CHANGELOG")

# --- 1. Bump pubspec.yaml version ---
sed -i.bak "s/^version: $CURRENT_VERSION\$/version: $NEW_VERSION/" "$PUBSPEC" && rm -f "$PUBSPEC.bak"
if ! grep -q "^version: $NEW_VERSION\$" "$PUBSPEC"; then
  echo "error: failed to update version in $PUBSPEC" >&2
  exit 1
fi

# --- 2. Optionally bump the pinned native-SDK dependencies ---
if [[ -n "$ANDROID_DEP" ]]; then
  CURRENT_ANDROID_DEP="$(sed -n "s/.*YMChatbot-Android:\(v[^']*\)'.*/\1/p" "$ANDROID_GRADLE")"
  sed -i.bak "s/YMChatbot-Android:$CURRENT_ANDROID_DEP'/YMChatbot-Android:$ANDROID_DEP'/" "$ANDROID_GRADLE" && rm -f "$ANDROID_GRADLE.bak"
  if ! grep -q "YMChatbot-Android:$ANDROID_DEP'" "$ANDROID_GRADLE"; then
    echo "error: failed to update the YMChatbot-Android pin in $ANDROID_GRADLE" >&2
    exit 1
  fi
  FILES_TO_COMMIT+=("$ANDROID_GRADLE")
fi

if [[ -n "$IOS_DEP" ]]; then
  CURRENT_IOS_DEP="$(sed -n "s/.*s.dependency 'YMChat', '~> \([^']*\)'.*/\1/p" "$PODSPEC")"
  sed -i.bak "s/s.dependency 'YMChat', '~> $CURRENT_IOS_DEP'/s.dependency 'YMChat', '~> $IOS_DEP'/" "$PODSPEC" && rm -f "$PODSPEC.bak"
  if ! grep -q "s.dependency 'YMChat', '~> $IOS_DEP'" "$PODSPEC"; then
    echo "error: failed to update the YMChat pin in $PODSPEC" >&2
    exit 1
  fi
  FILES_TO_COMMIT+=("$PODSPEC")
fi

# --- 3. Prepend CHANGELOG entry (this repo's flat style: no brackets/date/category) ---
ENTRY_FILE="$(mktemp)"
{
  echo "## ${NEW_VERSION}"
  for b in "${BULLETS[@]}"; do
    echo "- ${b}"
  done
  echo ""
} > "$ENTRY_FILE"

# Insert right before the first existing entry (or at EOF if the changelog
# has none yet).
awk -v entryfile="$ENTRY_FILE" '
  inserted { print; next }
  /^## [0-9]/ {
    while ((getline line < entryfile) > 0) print line
    inserted = 1
    print
    next
  }
  { print }
  END {
    if (!inserted) {
      while ((getline line < entryfile) > 0) print line
    }
  }
' "$CHANGELOG" > "$CHANGELOG.new" && mv "$CHANGELOG.new" "$CHANGELOG"
rm -f "$ENTRY_FILE"

git add "${FILES_TO_COMMIT[@]}"

COMMIT_MSG="Bump version to ${NEW_VERSION}"
if [[ -n "$ANDROID_DEP" || -n "$IOS_DEP" ]]; then
  COMMIT_MSG="Bump native SDK deps, update version to ${NEW_VERSION}"
fi
git commit -m "$COMMIT_MSG"

echo ""
echo "Done. Push this branch and open the PR as usual — merging to $INTEGRATION_BRANCH will"
echo "automatically tag ${TAG}, publish the GitHub Release, and publish to pub.dev."
