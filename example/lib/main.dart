import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ymchat_flutter/ymchat_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initilizeChatbot();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('YmChat Demo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            YmChat.startChatbot();
          },
          child: const Icon(Icons.message),
        ),
      ),
    );
  }

  void initilizeChatbot() {
    // Initializing chatbot id to work with in the SDK
    YmChat.setBotId("x1625119673009");

    // Adding payload to communicate with chatbot
    YmChat.setPayload({"integration": "Flutter"});

    // Enabling UI close button
    YmChat.showCloseButton(true);

    // Enabling voice input
    YmChat.setEnableSpeech(true);

    // using new widget
    YmChat.setVersion(2);

    // Setting statusbar color
    YmChat.setStatusBarColor("#ff0000");

    // Setting close button color
    YmChat.setCloseButtonColor("#0400ff");

    // Using lite version
    YmChat.useLiteVersion(true);

    // Listening to bot events
    EventChannel _ymEventChannel = const EventChannel("YMChatEvent");
    _ymEventChannel.receiveBroadcastStream().listen((event) {
      Map ymEvent = event;
      log("${ymEvent['code']} : ${ymEvent['data']}");
    });

    // Listening to close bot events
    EventChannel _ymCloseEventChannel = const EventChannel("YMBotCloseEvent");
    _ymCloseEventChannel.receiveBroadcastStream().listen((event) {
      bool ymCloseEvent = event;
      log(event.toString());
    });
  }
}
