import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/chatroom/blocs/chatroom_bloc.dart';
import 'package:tecky_chat/features/chatroom/blocs/message_list_bloc.dart';
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
          create: (context) => MessageListBloc(
            chatroomId: chatroomId,
            chatroomRepository: context.read<ChatroomRepository>(),
          ),
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
  final ScrollController _scrollController = ScrollController();

  void _onMessageSend(String message) {
    final completer = Completer<String>()
      ..future.then((_) => _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 450), curve: Curves.easeInOutCubic));

    context.read<ChatroomBloc>().add(ChatroomSendTextMessage(message, completer: completer));
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
        Expanded(child: BlocBuilder<MessageListBloc, MessageListState>(
          builder: (context, state) {
            return MessageList(
              messages: state.messages,
              scrollController: _scrollController,
            );
          },
        )),
        ChatroomInput(
          onMessageSend: _onMessageSend,
        ),
      ]),
    );
  }
}
