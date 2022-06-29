import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';

part 'message_list_event.dart';
part 'message_list_state.dart';

class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  final String chatroomId;
  final ChatroomRepository chatroomRepository;
  late final StreamSubscription<List<Message>> _messageListSubscription;

  MessageListBloc({
    required this.chatroomId,
    required this.chatroomRepository,
  }) : super(const MessageListState.initial()) {
    on<MessageListUpdated>(_onMessageListUpdated);
    _listenToMessageListChange();
  }

  @override
  close() async {
    super.close();
    _messageListSubscription.cancel();
  }

  _listenToMessageListChange() {
    _messageListSubscription = chatroomRepository
        .getMessageListStream(chatroomId)
        .listen((messages) => add(MessageListUpdated(messages)));
  }

  _onMessageListUpdated(MessageListUpdated event, Emitter emit) {
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

    emit(MessageListState.loaded(messages));
  }
}
