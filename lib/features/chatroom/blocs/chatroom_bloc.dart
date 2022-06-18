import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

class ChatroomBloc extends Bloc<ChatroomListChange, ChatroomState> {
  final ChatroomRepository chatroomRepository;
  late final StreamSubscription<List<Chatroom>> _contactListSubscription;

  ChatroomBloc({required this.chatroomRepository}) : super(ChatroomState.initial()) {
    on<ChatroomListChange>(_onChatroomListChange);

    _listenToChatroomList();
  }

  @override
  Future<void> close() async {
    super.close();
    _contactListSubscription.cancel();
  }

  _listenToChatroomList() {
    _contactListSubscription = chatroomRepository.chatrooms.listen((chatrooms) {
      add(ChatroomListChange(chatrooms));
    });
  }

  void _onChatroomListChange(ChatroomListChange event, Emitter emit) {
    emit(ChatroomState.loaded(event.chatrooms));
  }
}
