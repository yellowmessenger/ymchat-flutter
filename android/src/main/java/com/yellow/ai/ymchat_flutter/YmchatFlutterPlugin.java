package com.yellow.ai.ymchat_flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * YmchatFlutterPlugin
 */
public class YmchatFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native
    /// Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine
    /// and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel methodChannel;

    private EventChannel ymEventChannel;

    private EventChannel ymCloseBotEventChannel;

    private YmChatService ymChatService;

    private Context flutterContext;

    private EventChannel.EventSink eventSink;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.yellow.ai.ymchat");
        methodChannel.setMethodCallHandler(this);
        this.flutterContext = flutterPluginBinding.getApplicationContext();

        ymEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "YMChatEvent");
        ymCloseBotEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "YMBotCloseEvent");

        ymChatService = new YmChatService(ymEventChannel, ymCloseBotEventChannel);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "setBotId":
                setBotId(call, result);
                break;
            case "setDeviceToken":
                setDeviceToken(call, result);
                break;
            case "setEnableSpeech":
                setEnableSpeech(call, result);
                break;
            case "setAuthenticationToken":
                setAuthenticationToken(call, result);
                break;
            case "showCloseButton":
                showCloseButton(call, result);
                break;
            case "setCustomURL":
                setCustomURL(call, result);
                break;
            case "setPayload":
                setPayload(call, result);
                break;
            case "startChatbot":
                startChatbot(call, result);
                break;
            case "closeBot":
                closeBot(result);
                break;
            case "unLinkDeviceToken":
                unLinkDeviceToken(call, result);
                break;
            case "setVersion":
                setVersion(call, result);
                break;
            case "setCustomLoaderURL":
                setCustomLoaderURL(call, result);
                break;
            case "setStatusBarColor":
                setStatusBarColor(call, result);
                break;
            case "setCloseButtonColor":
                setCloseButtonColor(call, result);
                break;
            case "setMicIconColor":
                setMicIconColor(call, result);
                break;
            case "setMicBackgroundColor":
                setMicBackgroundColor(call, result);
                break;
            case "setDisableActionsOnLoad":
                setDisableActionsOnLoad(call, result);
                break;
            case "getUnreadMessages":
                getUnreadMessages(call, result);
                break;
            case "registerDevice":
                registerDevice(call, result);
                break;
            case "useLiteVersion":
                useLiteVersion(call, result);
                break;
            case "reloadBot":
                reloadBot(result);
                break;
            case "revalidateToken":
                revalidateToken(call, result);
                break;
            case "useSecureYmAuth":
                useSecureYmAuth(call, result);
                break;
            case "sendEventToBot":
                sendEventToBot(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void registerDevice(MethodCall call, Result result) {
        String apiKey = call.argument("apiKey");
        ymChatService.registerDevice(apiKey, result);
    }

    public void getUnreadMessages(MethodCall call, Result result) {
        ymChatService.getUnreadMessages(result);
    }

    public void useLiteVersion(MethodCall call, Result result) {
        Boolean shouldUseLiteVersion = call.argument("shouldUseLiteVersion");
        ymChatService.useLiteVersion(shouldUseLiteVersion);
        result.success(true);
    }

    public void revalidateToken(MethodCall call,Result result){
        String token = call.argument("token");
        Boolean refreshSession = call.argument("refreshSession");
        ymChatService.revalidateToken(token, refreshSession);
        result.success(true);
    }

    public void useSecureYmAuth(MethodCall call,Result result){
        Boolean shouldUseSecureYmAuth = call.argument("shouldUseSecureYmAuth");
        ymChatService.useSecureYmAuth(shouldUseSecureYmAuth);
        result.success(true);
    }

    public void setDisableActionsOnLoad(MethodCall call, Result result) {
        Boolean shouldDisableActionsOnLoad = call.argument("shouldDisableActionsOnLoad");
        ymChatService.setDisableActionsOnLoad(shouldDisableActionsOnLoad);
        result.success(true);
    }

    public void sendEventToBot(MethodCall call, Result result) {
        String code = call.argument("code");
        HashMap<String,Object> data  = call.argument("data";)
        ymChatService.sendEventToBot(code, data);
        result.success(true);
    }

    private void setCloseButtonColor(MethodCall call, Result result) {
        String color = call.argument("color");
        ymChatService.setCloseButtonColor(color);
        result.success(true);
    }

    private void setStatusBarColor(MethodCall call, Result result) {
        String color = call.argument("color");
        ymChatService.setStatusBarColor(color);
        result.success(true);
    }

    private void setMicIconColor(MethodCall call, Result result) {
        String color = call.argument("color");
        ymChatService.setMicIconColor(color);
        result.success(true);
    }

    private void setMicBackgroundColor(MethodCall call, Result result) {
        String color = call.argument("color");
        ymChatService.setMicBackgroundColor(color);
        result.success(true);
    }

    public void setBotId(MethodCall call, Result result) {
        String botId = call.argument("botId");
        ymChatService.setBotId(botId);
        result.success(true);
    }

    public void startChatbot(MethodCall call, Result result) {
        ymChatService.startChatbot(call, result, flutterContext);
    }

    public void closeBot(Result result) {
        ymChatService.closeBot();
        result.success(true);
    }

    public void reloadBot(Result result) {
        ymChatService.reloadBot();
        result.success(true);
    }

    public void setDeviceToken(MethodCall call, Result result) {
        String deviceToken = call.argument("deviceToken");
        ymChatService.setDeviceToken(deviceToken);
        result.success(true);
    }

    public void setEnableSpeech(MethodCall call, Result result) {
        Boolean shouldEnableSpeech = call.argument("shouldEnableSpeech");
        ymChatService.setEnableSpeech(shouldEnableSpeech);
        result.success(true);
    }

    public void setAuthenticationToken(MethodCall call, Result result) {
        String authenticationToken = call.argument("authenticationToken");
        ymChatService.setAuthenticationToken(authenticationToken);
        result.success(true);
    }

    public void showCloseButton(MethodCall call, Result result) {
        Boolean shouldShowCloseButton = call.argument("shouldEnableCloseButton");
        ymChatService.showCloseButton(shouldShowCloseButton);
        result.success(true);
    }

    public void setCustomURL(MethodCall call, Result result) {
        String customURL = call.argument("customURL");
        ymChatService.customBaseUrl(customURL);
        result.success(true);
    }

    public void setPayload(MethodCall call, Result result) {
        HashMap<String, Object> payload = call.argument("payload");
        ymChatService.setPayload(payload);
        result.success(true);
    }

    public void unLinkDeviceToken(MethodCall call, Result result) {
        String apiKey = call.argument("apiKey");
        ymChatService.unLinkDeviceToken(apiKey, call, result);
    }

    private void setVersion(MethodCall call, Result result) {
        int version = call.argument("version");
        ymChatService.setVersion(version);
        result.success(true);
    }

    public void setCustomLoaderURL(MethodCall call, Result result) {
        String customURL = call.argument("customLoaderURL");
        ymChatService.setCustomLoaderUrl(customURL);
        result.success(true);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
    }
}
