part of 'message_list_bloc.dart';

@immutable
abstract class MessageListEvent {}

class MessageListUpdated extends MessageListEvent {
  final List<Message> messages;

  MessageListUpdated(this.messages);
}
