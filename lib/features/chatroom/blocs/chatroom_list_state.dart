part of 'chatroom_list_bloc.dart';

enum ChatroomListStatus {
  loading,
  notLoaded,
  error,
  loaded,
}

class ChatroomListState {
  final List<Chatroom> chatrooms;
  final ChatroomListStatus chatroomListStatus;

  bool get isLoading => chatroomListStatus == ChatroomListStatus.loading;

  ChatroomListState._(
      {this.chatrooms = const [], this.chatroomListStatus = ChatroomListStatus.notLoaded});
  ChatroomListState.initial() : this._();
  ChatroomListState.loading() : this._(chatroomListStatus: ChatroomListStatus.loading);
  ChatroomListState.loaded(List<Chatroom> chatrooms)
      : this._(
          chatroomListStatus: ChatroomListStatus.loaded,
          chatrooms: chatrooms,
        );
}
