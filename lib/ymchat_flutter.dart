import 'dart:async';

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

  static Future<bool> setEnableHistory(bool shouldEnableHistory) async {
    bool isHistoryEnabled = await _channel.invokeMethod(
        'setEnableHistory', {"shouldEnableHistory": shouldEnableHistory});
    return isHistoryEnabled;
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
}
