part of 'chatroom_bloc.dart';

abstract class ChatroomEvent {
  const ChatroomEvent();
}

class ChatroomListChange extends ChatroomEvent {
  final List<Chatroom> chatrooms;

  ChatroomListChange(this.chatrooms);
}
