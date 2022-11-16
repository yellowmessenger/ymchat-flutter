package com.yellow.ai.ymchat_flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.yellowmessenger.ymchat.BotCloseEventListener;
import com.yellowmessenger.ymchat.YMChat;
import com.yellowmessenger.ymchat.YMConfig;
import com.yellowmessenger.ymchat.models.YellowCallback;
import com.yellowmessenger.ymchat.models.YellowDataCallback;
import com.yellowmessenger.ymchat.models.YellowUnreadMessageResponse;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class YmChatService {
    YMChat ymChat;
    final String Tag = "YmChat";
    final String ExceptionString = "Exception";
    final String code = "code";
    final String data = "data";

    private HashMap<String, Object> payloadData = new HashMap<>();
    private EventChannel.EventSink ymEventSink, closeEventSink;
    private EventChannel ymEventChannel, ymCloseBotEventChannel;

    YmChatService(EventChannel ymEventChannel, EventChannel ymCloseBotEventChannel) {
        this.ymChat = YMChat.getInstance();
        this.ymEventChannel = ymEventChannel;
        this.ymCloseBotEventChannel = ymCloseBotEventChannel;
        this.ymEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                ymEventSink = events;
            }

            @Override
            public void onCancel(Object arguments) {

            }
        });

        this.ymCloseBotEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                closeEventSink = events;
            }

            @Override
            public void onCancel(Object arguments) {

            }
        });
    }

    public void setBotId(String botId) {
        ymChat.config = new YMConfig(botId);
        ymChat.config.payload = payloadData;
        ymChat.onEventFromBot(botEvent -> {
            Map<String, Object> event = new HashMap<String, Object>();
            event.put(code, botEvent.getCode());
            event.put(data, botEvent.getData());
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    if (ymEventSink != null) {
                        ymEventSink.success(event);
                    }
                }
            });
        });

        ymChat.onBotClose(new BotCloseEventListener() {
            @Override
            public void onClosed() {
                if (closeEventSink != null) {
                    closeEventSink.success(true);
                }
            }
        });

    }

    public void startChatbot(MethodCall call, MethodChannel.Result result, Context context) {
        try {
            ymChat.startChatbot(context);
        } catch (Exception e) {
            e.printStackTrace();
            result.error("error in startChatbot", e.getMessage(), e);
        }
    }

    public void closeBot() {
        ymChat.closeBot();
    }

    public void setDeviceToken(String deviceToken) {
        ymChat.config.deviceToken = deviceToken;
    }

    public void setEnableSpeech(Boolean shouldEnableSpeech) {
        ymChat.config.enableSpeech = shouldEnableSpeech;
    }

    public void setAuthenticationToken(String authToken) {
        ymChat.config.ymAuthenticationToken = authToken;
    }

    public void showCloseButton(Boolean shouldShowCloseButton) {
        ymChat.config.showCloseButton = shouldShowCloseButton;
    }

    public void unLinkDeviceToken(String botId, String apiKey, String deviceToken, MethodCall call,
            MethodChannel.Result result) {
        try {
            ymChat.unlinkDeviceToken(botId, apiKey, deviceToken, new YellowCallback() {
                @Override
                public void success() {
                    result.success(true);
                }

                @Override
                public void failure(String message) {
                    result.success(message);
                }
            });
        } catch (Exception e) {
            result.error("error in unLinkDeviceToken", e.getMessage(), e);
        }
    }

    public void customBaseUrl(String url) {
        ymChat.config.customBaseUrl = url;
    }

    public void setPayload(HashMap<String, Object> payload) {
        ymChat.config.payload.putAll(payload);
    }

    public void setVersion(int version) {
        ymChat.config.version = version;
    }

    public void setCustomLoaderUrl(String url) {
        ymChat.config.customLoaderUrl = url;
    }

    public void setCloseButtonColor(String color) {
        ymChat.config.closeButtonColorFromHex = color;
    }

    public void setStatusBarColor(String color) {
        ymChat.config.statusBarColorFromHex = color;
    }

    public void setDisableActionsOnLoad(Boolean shouldDisableActionsOnLoad) {
        ymChat.config.disableActionsOnLoad = shouldDisableActionsOnLoad;
    }

    public void getUnreadMessages(MethodChannel.Result result) {
        try {
            ymChat.getUnreadMessagesCount(ymChat.config, new YellowDataCallback() {
                @Override
                public <T> void success(T data) {
                    YellowUnreadMessageResponse response = (YellowUnreadMessageResponse) data;
                    result.success(response.getUnreadCount());
                }

                @Override
                public void failure(String message) {
                    HashMap<String, String> errorObject = new HashMap<String, String>();
                    errorObject.put("error", message);
                    result.success(errorObject);
                }
            });
        } catch (Exception e) {
            result.error("error in getUnreadMessages", e.getMessage(), e);
        }
    }

    public void registerDevice(String apiKey, MethodChannel.Result result) {
        try {
            ymChat.registerDevice(apiKey, ymChat.config, new YellowCallback() {
                @Override
                public void success() {
                    result.success(true);
                }

                @Override
                public void failure(String message) {
                    result.success(message);
                }
            });
        } catch (Exception e) {
            result.error("error in registerDevice", e.getMessage(), e);
        }
    }

    public void useLiteVersion(Boolean shouldUseLiteVersion) {
        ymChat.config.useLiteVersion = shouldUseLiteVersion;
    }
}
