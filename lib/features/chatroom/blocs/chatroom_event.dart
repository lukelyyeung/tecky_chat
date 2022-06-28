part of 'chatroom_bloc.dart';

@immutable
abstract class ChatroomEvent {}

class ChatroomUpdated extends ChatroomEvent {
  final Chatroom chatroom;

  ChatroomUpdated(this.chatroom);
}