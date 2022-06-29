part of 'message_list_bloc.dart';

enum MessageListStatus {
  loading,
  notLoaded,
  error,
  loaded,
}

@immutable
class MessageListState {
  final List<Message> messages;
  final MessageListStatus status;

  const MessageListState._({this.messages = const [], this.status = MessageListStatus.notLoaded});

  const MessageListState.initial() : this._();
  const MessageListState.loaded(List<Message> messages)
      : this._(messages: messages, status: MessageListStatus.loaded);
}
