import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';

part 'chatroom_list_event.dart';
part 'chatroom_list_state.dart';

class ChatroomListBloc extends Bloc<ChatroomListChange, ChatroomListState> {
  final ChatroomRepository chatroomRepository;
  late final StreamSubscription<List<Chatroom>> _contactListSubscription;

  ChatroomListBloc({required this.chatroomRepository}) : super(ChatroomListState.initial()) {
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
    emit(ChatroomListState.loaded(event.chatrooms));
  }
}
