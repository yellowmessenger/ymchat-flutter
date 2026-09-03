## 3.5.3
- No functional change — validates the automated tag/CHANGELOG/GitHub Release/pub.dev-publish pipeline end-to-end (see #131).

## 3.5.2
- Upgraded native Android SDK to pick up a text-to-speech fallback for the widget's Read aloud button — Android `YMChatbot-Android` 3.5.1. `android.webkit.WebView` doesn't implement `window.speechSynthesis`, so the button previously did nothing there; it now falls back to a native `TextToSpeech` bridge. No Dart API changes.

## 3.5.1
- Upgraded native iOS SDK to pick up a WebView keyboard-resize fix — iOS `YMChat` 2.4.1. The embedded WKWebView now resizes when the on-screen keyboard opens, keeping input fields visible instead of being covered. No Dart API changes.

## 3.5.0
- **Auto-Sent Initial User Message** — lets the host app automatically send a configured message as soon as the chat widget opens, rendered as a real outgoing user message, via `YmChat.setInitialUserMessage('...')`. Bridges the native SDKs' `initialUserMessage` config to Dart for the first time (`YMChatbot-Android` since v3.5.0, iOS `YMChat` since 2.4.0 — this package now requires those versions or newer).

## 3.4.0
- **Configurable Upload Sources** (Android only) — restricts the attachment picker to specific sources via `YmChat.setAllowedUploadSources(['camera'])` (or `['file']`, or both). Bridges the native Android SDK's `allowedUploadSources` config to Dart for the first time (`YMChatbot-Android` since v3.3.0, already pinned by this package). No iOS equivalent exists natively, so this call has no effect on iOS.

## 3.3.0
- **Activation Mode** — lets the host app open the widget directly into voice mode instead of chat, via `YmChat.setActivationMode('voice')` (or `'chat'`, the default). Bridges the native SDKs' `activationMode` config to Dart for the first time (iOS `YMChat` since 2.1.0, Android `YMChatbot-Android` since v3.1.0 — both already pinned by this package).

## 3.2.0
- Upgraded native SDKs to pick up automatic screen-awake handling during Voice Mode — Android YMChatbot-Android v3.4.0, iOS YMChat 2.3.0. The screen now stays on for the duration of an active voice conversation and returns to normal on call end; entirely internal to the native SDKs, no Dart API changes.

## 3.1.2
- Security fix: upgraded native Android SDK to YMChatbot-Android v3.3.2, closing a residual WebView popup (`window.open()`) URL-scheme gap left over from the v3.3.1 fix. No Dart API changes.

## 3.1.1
- Security fix: upgraded native SDKs to pick up a WebView URL-handling fix — Android YMChatbot-Android v3.3.1, iOS YMChat 2.2.1. No Dart API changes.

## 3.1.0
- added `stopVoiceMode` method to programmatically stop the bot's voice mode.

## 3.0.0
- Added support for chatbot Version 3 (V3 widget). Upgraded native SDKs: Android YMChatbot-Android v3.3.0, iOS YMChat 2.2.0. Call `setVersion(3)` before `startChatbot()` to use it.

## 2.22.0
- package updated to support Android target API level 35 for compatibility with latest Android versions.

## 2.21.1
- package updated for an andriod bug fix. Earlier chatbot UI was overlapping the system bars due to edge to edge layout implementation when target SDK is set to 35 or higher, and is running Android 15 or higher device.

## 2.21.0
- added `YMBotLoadFailedEvent` event channel to let user know that bot load failed due to certain technical issue.

## 2.20.1
- added `setThemeLinkColor` method to set the link color in chatbot.

## 2.19.0
- Added an option that prevents links from opening in the browser. Use `setOpenLinkExternally` to prevent opening url in new window, and listen to `url-clicked` event in `YMChatEvent` to get the url of the link clicked.

## 2.18.3
- package updated for an andriod bug fix. There was a memory leak mainly because botCloseEventListener wasn't de-initialized earlier and was retaining references to the fragment

## 2.18.2
- package updated for an andriod bug fix. Device location status is now checked before invoking GeolocationPermissions callback when the location permission is granted by the user

## 2.18.1
- package updated to support Android's newer gradle versions

## 2.18.0
- package updated to remove storage permissions in Android to comply with Google Play's new Policy

## 2.17.0

- added `setMicButtonMovable` method to set mic button as movable or static

## 2.16.0

- iOS sdk `YMChat` updated to 1.20

## 2.15.0

- added `setChatContainerTheme` method to set theme for chat container

## 2.14.0

- android `targetSdkVersion` and `compileSdkVersion` upgraded to 34

## 2.13.0

- added `setThemeBotBubbleBackgroundColor` method to make change for background color for bot bubble

## 2.11.1

- The function `startChatbot()` returns a success signal upon completing its execution successfully

## 2.11.0

- Passing App Ids for App Whitelisting feature

## 2.10.1

- Exposed `theme` option in ymConfig to control bot name, bot description and some other properties in bot

## 2.10.0

- Exposed `theme` option in ymConfig to control bot name, bot description and some other properties in bot

## 2.9.0

- Exposing a controlled api (sendEventToBot(model)) for sending event to bot

## 2.8.0

- Added support for secure YMAuth.

## 2.7.1

- Removed unused imports. 

## 2.7.0

- Android API update
- Background & Foreground Event
- Fixed `unlinkDevice` API

## 2.6.2

- Fixed `registerDevice` crash issue

## 2.6.1

- iOS `reloadBot` API issue resolved

## 2.6.0

- Android - Authority changes added

## 2.5.0

- Floating Mic Button added
- Exposed `setMicIconColor` & `setMicBackgroundColor` for mic properties

## 2.4.0

- `reloadBot` Api Added

## 2.3.5

- Fixed iOS `closeBot` Api issue

## 2.3.4

- Fixed iOS event not coming for release version issue

## 2.3.3

- Fixed iOS event sink issue

## 2.3.2

- Fixed iOS `closeBot` Api issue

## 2.3.1

- Fixed iOS events not working issue

## 2.3.0

- Changed iOS payload nested structure to keep in sync with android (can be accessed in bot by app.profile instead of app.profile.profile)

## 2.2.3

- Added try catch around events sinks to handle crash

## 2.2.2

- Fixed getUnreadMessages API error

## 2.2.1

- Fixed missing declarations for `getUnreadMessagesCount` and `registerDevice` API

## 2.2.0

- Added `getUnreadMessagesCount` api to get unread messages count when bot is closed
- Added `registerDevice` api to register device for push notification without launching the bot

## 2.1.2

- Added `useLiteVersion` api to use lite version of bot

## 2.1.1

- Fixed event sink null pointer issues
- Added setDisableActionsOnLoad flag, when set to true Input bar will not be shown while bot is loading

## 2.1.0

- Fixed Unlink Device Token issue
- Fixed location permission issue for android
- Removed internal SDK permissions for android (all permission should be added in host app manifest file)## 2.0.0

- Fixed corrupted ymAuthenticationToken

## 1.5.0

- Renamed setStatusBarColour, setCloseButtonColour API to setStatusBarColor, setCloseButtonColor respectively

## 1.4.0

- Added setStatusBarColour, setCloseButtonColour API's (for setting colour to status bar and close button colours respectively)

## 1.3.1

- Handling null event handlers

## 1.3.0

- Added setCustomLoaderURL API (for setting custom loading image for chatbot)

## 1.2.1

- Fixed unlink device token API

## 1.2.0

- Added v2 widget support

## 1.1.1

- Added dynamic versioning for Android and iOS

## 1.1.0

- Removed enableHistory API
- Added UnLinkDeviceToken API

## 1.0.0

- TODO: Describe initial release.
