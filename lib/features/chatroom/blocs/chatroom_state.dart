part of 'chatroom_bloc.dart';

@immutable
class ChatroomState {
  final Chatroom chatroom;

  const ChatroomState._({this.chatroom = Chatroom.empty});

  const ChatroomState.initial() : this._();
  const ChatroomState.loaded(Chatroom chatroom) : this._(chatroom: chatroom);
}
