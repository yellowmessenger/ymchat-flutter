import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';

class YmChat {
  static const MethodChannel _channel = MethodChannel('com.yellow.ai.ymchat');

  static Future<bool> setBotId(String botId) async {
    bool isBotIdAssigned =
        await _channel.invokeMethod('setBotId', {"botId": botId});
    return isBotIdAssigned;
  }

  static Future<bool> setDeviceToken(String deviceToken) async {
    bool isdeviceTokenAssigned = await _channel
        .invokeMethod('setDeviceToken', {"deviceToken": deviceToken});
    return isdeviceTokenAssigned;
  }

  static Future<bool> revalidateToken(String token, bool refreshSession) async {
    bool isRevalidateToken = await _channel.invokeMethod(
        "revalidateToken", {"token": token, "refreshSession": refreshSession});
    return isRevalidateToken;
  }

  static Future<bool> useSecureYmAuth(bool shouldUseSecureYmAuth) async {
    bool isUseSecureYmAuth = await _channel.invokeMethod(
        "useSecureYmAuth", {"shouldUseSecureYmAuth": shouldUseSecureYmAuth});
    return isUseSecureYmAuth;
  }

  static Future<bool> sendEventToBot(
      String code, Map<String, Object> data) async {
    bool isSendEventToBot = await _channel
        .invokeMethod("sendEventToBot", {"code": code, "data": data});
    return isSendEventToBot;
  }

  static Future<bool> setEnableSpeech(bool shouldEnableSpeech) async {
    bool isSpeechEnabled = await _channel.invokeMethod(
        'setEnableSpeech', {"shouldEnableSpeech": shouldEnableSpeech});
    return isSpeechEnabled;
  }

  static Future<bool> setAuthenticationToken(String authenticationToken) async {
    bool isAuthenticationTokenAssigned = await _channel.invokeMethod(
        'setAuthenticationToken', {"authenticationToken": authenticationToken});
    return isAuthenticationTokenAssigned;
  }

  static Future<bool> showCloseButton(bool shouldEnableCloseButton) async {
    bool isCloseButtonVisible = await _channel.invokeMethod('showCloseButton',
        {"shouldEnableCloseButton": shouldEnableCloseButton});
    return isCloseButtonVisible;
  }

  static Future<bool> setCustomURL(String customURL) async {
    bool isCustomURLSet =
        await _channel.invokeMethod('setCustomURL', {"customURL": customURL});
    return isCustomURLSet;
  }

  static Future<bool> setPayload(Map<String, Object> payload) async {
    bool isPayloadAssigned =
        await _channel.invokeMethod('setPayload', {"payload": payload});
    return isPayloadAssigned;
  }

  static Future<bool> startChatbot() async {
    bool isBotStarted = await _channel.invokeMethod('startChatbot');
    return isBotStarted;
  }

  static Future<bool> closeBot() async {
    bool isBotClosed = await _channel.invokeMethod('closeBot');
    return isBotClosed;
  }

  static Future<void> unLinkDeviceToken(
    String apiKey,
    void Function() successCallback,
    void Function(dynamic) failureCallback,
  ) async {
    dynamic unLinkDeviceTokenResult =
        await _channel.invokeMethod('unLinkDeviceToken', {'apiKey': apiKey});
    if (unLinkDeviceTokenResult == true) {
      successCallback();
    } else {
      failureCallback(unLinkDeviceTokenResult);
    }
  }

  static Future<bool> setVersion(int version) async {
    bool isVersionAssigned =
        await _channel.invokeMethod('setVersion', {"version": version});
    return isVersionAssigned;
  }

  static Future<bool> setCustomLoaderURL(String customURL) async {
    bool isCustomLoaderURLSet = await _channel
        .invokeMethod('setCustomLoaderURL', {"customLoaderURL": customURL});
    return isCustomLoaderURLSet;
  }

  static Future<bool> setStatusBarColor(String color) async {
    bool isStatusBarColorSet =
        await _channel.invokeMethod('setStatusBarColor', {"color": color});
    return isStatusBarColorSet;
  }

  static Future<bool> setCloseButtonColor(String color) async {
    bool isCloseButtonColorSet =
        await _channel.invokeMethod('setCloseButtonColor', {"color": color});
    return isCloseButtonColorSet;
  }

  static Future<bool> setMicIconColor(String color) async {
    bool isMicIconColorSet =
        await _channel.invokeMethod('setMicIconColor', {"color": color});
    return isMicIconColorSet;
  }

  static Future<bool> setMicBackgroundColor(String color) async {
    bool isMicBackgroundColorSet =
        await _channel.invokeMethod('setMicBackgroundColor', {"color": color});
    return isMicBackgroundColorSet;
  }

  static Future<bool> setMicButtonToStatic() async {
    bool isMicButtonSetToStatic =
        await _channel.invokeMethod('setMicButtonToStatic');
    return isMicButtonSetToStatic;
  }

  static Future<bool> setDisableActionsOnLoad(
      bool shouldDisableActionsOnLoad) async {
    bool isDisableActionsOnLoad = await _channel.invokeMethod(
        'setDisableActionsOnLoad',
        {"shouldDisableActionsOnLoad": shouldDisableActionsOnLoad});
    return isDisableActionsOnLoad;
  }

  static Future registerDevice(
    String apiKey,
    void Function(bool) successCallback,
    void Function(dynamic) failureCallback,
  ) async {
    dynamic unReadMessagesResponse =
        await _channel.invokeMethod('registerDevice', {'apiKey': apiKey});
    if (unReadMessagesResponse is bool) {
      successCallback(unReadMessagesResponse);
    } else {
      failureCallback(unReadMessagesResponse);
    }
  }

  static Future getUnreadMessages(
    void Function(String) successCallback,
    void Function(dynamic) failureCallback,
  ) async {
    dynamic unReadMessagesResponse =
        await _channel.invokeMethod('getUnreadMessages');
    if (unReadMessagesResponse is String) {
      successCallback(unReadMessagesResponse);
    } else if (unReadMessagesResponse is LinkedHashMap) {
      failureCallback(unReadMessagesResponse["error"]);
    } else {
      failureCallback(unReadMessagesResponse);
    }
  }

  static Future<bool> useLiteVersion(bool shouldUseLiteVersion) async {
    bool isUsingLiteVersion = await _channel.invokeMethod(
        'useLiteVersion', {"shouldUseLiteVersion": shouldUseLiteVersion});
    return isUsingLiteVersion;
  }

  static Future<bool> reloadBot() async {
    bool isBotReloaded = await _channel.invokeMethod('reloadBot');
    return isBotReloaded;
  }

  static Future<bool> setThemeBotName(String name) async {
    bool isThemeBotNameAssigned =
        await _channel.invokeMethod('setThemeBotName', {"name": name});
    return isThemeBotNameAssigned;
  }

  static Future<bool> setThemeBotDescription(String description) async {
    bool isThemeBotDescriptionAssigned = await _channel
        .invokeMethod('setThemeBotDescription', {"description": description});
    return isThemeBotDescriptionAssigned;
  }

  static Future<bool> setThemePrimaryColor(String color) async {
    bool isThemePrimaryColorAssigned =
        await _channel.invokeMethod('setThemePrimaryColor', {"color": color});
    return isThemePrimaryColorAssigned;
  }

  static Future<bool> setThemeSecondaryColor(String color) async {
    bool isThemeSecondaryColorAssigned =
        await _channel.invokeMethod('setThemeSecondaryColor', {"color": color});
    return isThemeSecondaryColorAssigned;
  }

  static Future<bool> setThemeBotBubbleBackgroundColor(String color) async {
    bool isThemeBotBubbleBackgroundColorAssigned = await _channel
        .invokeMethod('setThemeBotBubbleBackgroundColor', {"color": color});
    return isThemeBotBubbleBackgroundColorAssigned;
  }

  static Future<bool> setThemeBotIcon(String iconUrl) async {
    bool isThemeBotIconAssigned =
        await _channel.invokeMethod('setThemeBotIcon', {"iconUrl": iconUrl});
    return isThemeBotIconAssigned;
  }

  static Future<bool> setThemeBotClickIcon(String iconUrl) async {
    bool isThemeBotClickIconAssigned = await _channel
        .invokeMethod('setThemeBotClickIcon', {"iconUrl": iconUrl});
    return isThemeBotClickIconAssigned;
  }

  static Future<bool> setChatContainerTheme(String theme) async {
    bool isThemeBotClickIconAssigned =
        await _channel.invokeMethod('setChatContainerTheme', {"theme": theme});
    return isThemeBotClickIconAssigned;
  }
}
