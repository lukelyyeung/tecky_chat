import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/chatroom/blocs/chatroom_bloc.dart';
import 'package:tecky_chat/features/chatroom/blocs/message_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatroomBloc(
              authRepository: context.read<AuthRepository>(),
              chatroomId: chatroomId,
              chatroomRepository: context.read<ChatroomRepository>()),
        ),
        BlocProvider(
          create: (context) => MessageBloc(
              chatroomId: chatroomId, chatroomRepository: context.read<ChatroomRepository>()),
        ),
      ],
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
  final scrollController = ScrollController();

  void _onMessageSend(String textContent) {
    final completer = Completer<String>()
      ..future.then((_) {
        scrollController.animateTo(0,
            duration: const Duration(milliseconds: 400), curve: Curves.easeInOutExpo);
      });

    context.read<ChatroomBloc>().add(ChatroomSendTextMessage(textContent, completer: completer));
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
        Expanded(child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            return MessageList(scrollController: scrollController, messages: state.messages);
          },
        )),
        ChatroomInput(
          onMessageSend: _onMessageSend,
        ),
      ]),
    );
  }
}
