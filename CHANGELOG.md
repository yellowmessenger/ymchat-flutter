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
