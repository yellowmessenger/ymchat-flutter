import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:ffi';

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
    String botId,
    String apiKey,
    String deviceToken,
    void Function() successCallback,
    void Function(dynamic) failureCallback,
  ) async {
    dynamic unLinkDeviceTokenResult = await _channel.invokeMethod(
        'unLinkDeviceToken',
        {'botId': botId, 'apiKey': apiKey, 'deviceToken': deviceToken});
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
}
