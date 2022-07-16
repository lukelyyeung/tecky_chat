import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';
import 'package:tecky_chat/features/file/repositories/file_repository.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

class ChatroomBloc extends Bloc<ChatroomEvent, ChatroomState> {
  final String chatroomId;
  final AuthRepository authRepository;
  final ChatroomRepository chatroomRepository;
  final FileRepository fileRepository;
  late final StreamSubscription<Chatroom> _chatroomSubscription;

  ChatroomBloc({
    required this.chatroomId,
    required this.chatroomRepository,
    required this.authRepository,
    required this.fileRepository,
  }) : super(const ChatroomState.initial()) {
    on<ChatroomUpdated>(_onChatroomUpdated);
    on<ChatroomSendTextMessage>(_onChatroomSendTextMessage);
    on<ChatroomSendImageMessage>(_onChatroomSendImageMessage);
    _listenToChatroomUpdate();
  }

  @override
  Future<void> close() async {
    super.close();
    _chatroomSubscription.cancel();
  }

  _listenToChatroomUpdate() {
    _chatroomSubscription = chatroomRepository
        .getChatroomStream(chatroomId)
        .listen((chatroom) => add(ChatroomUpdated(chatroom)));
  }

  _onChatroomUpdated(ChatroomUpdated event, Emitter emit) {
    emit(ChatroomState.loaded(event.chatroom));
  }

  _onChatroomSendTextMessage(ChatroomSendTextMessage event, Emitter emit) async {
    final currentUser = await authRepository.currentUserStream.first;
    final message = Message.fromText(currentUser.id, textContent: event.textContent);

    final messageId = await chatroomRepository.sendMessage(chatroomId, message);

    event.completer?.complete(messageId);
  }

  _onChatroomSendImageMessage(ChatroomSendImageMessage event, Emitter emit) async {
    final currentUser = await authRepository.currentUserStream.first;
    final message =
        Message.fromImages(currentUser.id, textContent: event.textContent ?? '', mediaFiles: []);

    final messageId = await chatroomRepository.sendMessage(chatroomId, message);
    event.completer?.complete(messageId);

    try {
      final imageUrls = await Future.wait(event.images.map((image) {
        final randomFileName = DateTime.now().microsecondsSinceEpoch.toString();
        final ext = image.path.split('.').last;
        final path = 'chatrooms/$chatroomId/messages/${message.id}/$randomFileName.$ext';

        return fileRepository.uploadFile(path, image);
      }).toList());

      // Update image message's mediaFile
      await chatroomRepository.setFileMessageUploaded(chatroomId, messageId, mediaFiles: imageUrls);
    } catch (_) {
      // error handling -> set image message status to error
      chatroomRepository.setFileMessageUploadFailed(chatroomId, messageId);
    }
  }
}
