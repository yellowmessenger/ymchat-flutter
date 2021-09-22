package com.yellow.ai.ymchat_flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import com.yellowmessenger.ymchat.BotCloseEventListener;
import com.yellowmessenger.ymchat.YMChat;
import com.yellowmessenger.ymchat.YMConfig;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

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
                    ymEventSink.success(event);
                }
            });
        });

        ymChat.onBotClose(new BotCloseEventListener() {
            @Override
            public void onClosed() {
                closeEventSink.success(true);
            }
        });

    }

    public void startChatbot(Context context) {
        try {
            ymChat.startChatbot(context);
        } catch (Exception e) {
            e.printStackTrace();
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

    public void setEnableHistory(Boolean shouldEnableHistory) {
        ymChat.config.enableHistory = shouldEnableHistory;
    }

    public void setAuthenticationToken(String authToken) {
        ymChat.config.ymAuthenticationToken = authToken;
    }

    public void showCloseButton(Boolean shouldShowCloseButton) {
        ymChat.config.showCloseButton = shouldShowCloseButton;
    }

    public void customBaseUrl(String url) {
        ymChat.config.customBaseUrl = url;
    }

    public void setPayload(HashMap<String, Object> payload) {
        ymChat.config.payload.putAll(payload);
    }
}

