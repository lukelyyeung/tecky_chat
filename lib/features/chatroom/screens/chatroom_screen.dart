import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/chatroom/blocs/chatroom_bloc.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';
import 'package:tecky_chat/features/chatroom/widgets/chatroom_app_bar.dart';
import 'package:tecky_chat/features/chatroom/widgets/chatroom_input.dart';
import 'package:tecky_chat/features/chatroom/widgets/message_list.dart';

class ChatroomScreen extends StatelessWidget {
  final String chatroomId;
  const ChatroomScreen({Key? key, required this.chatroomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatroomBloc(
          chatroomId: chatroomId, chatroomRepository: context.read<ChatroomRepository>()),
      child: const _ChatroomScreen(),
    );
  }
}

class _ChatroomScreen extends StatefulWidget {
  const _ChatroomScreen({Key? key}) : super(key: key);

  @override
  State<_ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<_ChatroomScreen> {
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ChatroomBloc, ChatroomState>(
          buildWhen: (previous, current) =>
              previous.chatroom.displayName != current.chatroom.displayName,
          builder: (context, state) => ChatroomAppBar(title: state.chatroom.displayName),
        ),
      ),
      body: Column(children: [
        Expanded(child: MessageList(messages: _messages)),
        ChatroomInput(
          onMessageSend: _onMessageSend,
        ),
      ]),
    );
  }
}
