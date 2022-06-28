import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

class ChatroomBloc extends Bloc<ChatroomEvent, ChatroomState> {
  final String chatroomId;
  final ChatroomRepository chatroomRepository;
  late final StreamSubscription<Chatroom> _chatroomSubscription;

  ChatroomBloc({
    required this.chatroomId,
    required this.chatroomRepository,
  }) : super(const ChatroomState.initial()) {
    on<ChatroomUpdated>(_onChatroomUpdated);
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
}
