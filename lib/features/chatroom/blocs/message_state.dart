part of 'message_bloc.dart';

@immutable
class MessageState {
  final List<Message> messages;

  const MessageState._({this.messages = const []});
  const MessageState.initial() : this._();
  const MessageState.loaded(List<Message> messages) : this._(messages: messages);
}
