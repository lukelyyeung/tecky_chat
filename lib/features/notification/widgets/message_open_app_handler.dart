import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageOpenAppHandler extends StatefulWidget {
  final Widget child;
  const MessageOpenAppHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<MessageOpenAppHandler> createState() => _MessageOpenAppHandlerState();
}

class _MessageOpenAppHandlerState extends State<MessageOpenAppHandler> {
  late final StreamSubscription<RemoteMessage> _messageOpenAppSubscription;

  @override
  void initState() {
    super.initState();

    _messageOpenAppSubscription = FirebaseMessaging
      .onMessageOpenedApp
      .where((message) => message.data['chatroomId'] != null)
      .listen((message) {
        final chatroomId = message.data['chatroomId'];
        context.push('/chats/$chatroomId');
      });
  }

  @override
  void dispose() {
    _messageOpenAppSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}