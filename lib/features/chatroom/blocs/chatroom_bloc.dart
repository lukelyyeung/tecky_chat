import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

class ChatroomBloc extends Bloc<ChatroomEvent, ChatroomState> {
  final String chatroomId;
  final AuthRepository authRepository;
  final ChatroomRepository chatroomRepository;
  late final StreamSubscription<Chatroom> _chatroomSubscription;

  ChatroomBloc({
    required this.chatroomId,
    required this.chatroomRepository,
    required this.authRepository,
  }) : super(const ChatroomState.initial()) {
    on<ChatroomUpdated>(_onChatroomUpdated);
    on<ChatroomSendTextMessage>(_onChatroomSendTextMessage);
    _listenToChatroomUpdate();
  }

  @override
  Future<void> close() async {
    super.close();
    _chatroomSubscription.cancel();
  }

  _listenToChatroomUpdate() {
    _chatroomSubscription = chatroomRepository
        .getChatroomStream(chatroomId)
        .listen((chatroom) => add(ChatroomUpdated(chatroom)));
  }

  _onChatroomUpdated(ChatroomUpdated event, Emitter emit) {
    emit(ChatroomState.loaded(event.chatroom));
  }

  _onChatroomSendTextMessage(ChatroomSendTextMessage event, Emitter emit) async {
    final currentUser = await authRepository.currentUserStream.first;
    final message = Message.fromText(currentUser.id, textContent: event.textContent);

    final messageId = await chatroomRepository.sendMessage(chatroomId, message);

    event.completer?.complete(messageId);
  }
}
