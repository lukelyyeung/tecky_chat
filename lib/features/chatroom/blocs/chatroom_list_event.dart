part of 'chatroom_list_bloc.dart';

abstract class ChatroomListEvent {
  const ChatroomListEvent();
}

class ChatroomListChange extends ChatroomListEvent {
  final List<Chatroom> chatrooms;

  ChatroomListChange(this.chatrooms);
}
