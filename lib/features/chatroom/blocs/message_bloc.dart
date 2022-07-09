import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final String chatroomId;
  final ChatroomRepository chatroomRepository;
  late final StreamSubscription<List<Message>> _messageSubscription;
  MessageBloc({required this.chatroomId, required this.chatroomRepository})
      : super(const MessageState.initial()) {
    on<MessageListChange>(_onMessageListChange);
    _listenToMessageStream();
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    return super.close();
  }

  void _listenToMessageStream() {
    _messageSubscription = chatroomRepository
        .getMessageStream(chatroomId)
        .listen((messages) => add(MessageListChange(messages)));
  }

  void _onMessageListChange(MessageListChange event, Emitter emit) {
    final messages = event.messages.fold<List<Message>>([], (acc, cur) {
      if (acc.isEmpty) {
        acc.add(cur);
        return acc;
      }

      final lastCreatedAt = acc.last.createdAt;
      final createdAt = cur.createdAt;

      if (lastCreatedAt?.year != createdAt?.year || lastCreatedAt?.day != createdAt?.day) {
        acc.add(Message.fromDate(acc.last.createdAt ?? DateTime.now()));
      }

      acc.add(cur);

      if (cur == event.messages.last) {
        acc.add(Message.fromDate(cur.createdAt ?? DateTime.now()));
      }
      return acc;
    });

    emit(MessageState.loaded(messages));
  }
}
