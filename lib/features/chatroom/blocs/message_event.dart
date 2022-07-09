part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class MessageListChange extends MessageEvent {
  final List<Message> messages;

  MessageListChange(this.messages);
}