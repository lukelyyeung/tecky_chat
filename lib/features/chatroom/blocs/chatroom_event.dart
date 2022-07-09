part of 'chatroom_bloc.dart';

@immutable
abstract class ChatroomEvent {}

class ChatroomUpdated extends ChatroomEvent {
  final Chatroom chatroom;

  ChatroomUpdated(this.chatroom);
}

class ChatroomSendTextMessage extends ChatroomEvent {
  final String textContent;
  final Completer<String>? completer;

  ChatroomSendTextMessage(this.textContent, {this.completer});
}
