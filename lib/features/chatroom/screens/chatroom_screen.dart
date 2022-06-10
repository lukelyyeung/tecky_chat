import 'package:flutter/material.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/widgets/chatroom_app_bar.dart';
import 'package:tecky_chat/features/chatroom/widgets/chatroom_input.dart';
import 'package:tecky_chat/features/chatroom/widgets/message_list.dart';

class ChatroomScreen extends StatefulWidget {
  final String title;
  const ChatroomScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  final _messages = [
    Message(textContent: 'Hello World', authorId: 'fake-my-id'),
    Message(textContent: 'Is this your 1st Flutter Application?', authorId: 'not-my-id'),
    Message(textContent: 'Yes. Flutter is really simple and fast.', authorId: 'not-my-id'),
    Message(textContent: '---', authorId: 'system'),
    Message(textContent: 'Also, its built-in UI component is so nice.', authorId: 'fake-my-id'),
  ];

  void _onMessageSend(Message message) {
    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatroomAppBar(title: widget.title),
      body: Column(children: [
        Expanded(child: MessageList(messages: _messages)),
        ChatroomInput(
          onMessageSend: _onMessageSend,
        ),
      ]),
    );
  }
}
