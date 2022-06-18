part of 'chatroom_bloc.dart';

enum ChatroomListStatus {
  loading,
  notLoaded,
  error,
  loaded,
}

class ChatroomState {
  final List<Chatroom> chatrooms;
  final ChatroomListStatus chatroomListStatus;

  bool get isLoading => chatroomListStatus == ChatroomListStatus.loading;

  ChatroomState._(
      {this.chatrooms = const [], this.chatroomListStatus = ChatroomListStatus.notLoaded});
  ChatroomState.initial() : this._();
  ChatroomState.loading() : this._(chatroomListStatus: ChatroomListStatus.loading);
  ChatroomState.loaded(List<Chatroom> chatrooms)
      : this._(
          chatroomListStatus: ChatroomListStatus.loaded,
          chatrooms: chatrooms,
        );
}
