import 'package:flutter/material.dart';
import 'package:tecky_chat/features/chatroom/widgets/chatroom_app_bar.dart';
import 'package:tecky_chat/features/chatroom/widgets/chatroom_input.dart';
import 'package:tecky_chat/features/chatroom/widgets/message_list.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  final _messages = [
    'Hello World',
    'Is this your 1st Flutter Application?',
    'Yes. Flutter is really simple and fast.',
    '---',
    'Also, its built-in UI component is so nice.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatroomAppBar(title: 'Athalia Putri'),
      body: Column(children: [
        Expanded(child: MessageList(messages: _messages)),
        const ChatroomInput(),
      ]),
    );
  }
}
