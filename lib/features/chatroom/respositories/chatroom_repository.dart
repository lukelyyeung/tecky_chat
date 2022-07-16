import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:tecky_chat/extensions/extended_document_snasphot.dart';
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/common/models/user.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';

class _ChatroomCollectionPaths {
  static const chatrooms = 'chatrooms';
  static getChatoomPath(String chatroomId) => 'chatrooms/$chatroomId';
  static getMessagePath(String chatroomId) => 'chatrooms/$chatroomId/messages';
}

class ChatroomRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final UserRepository userRepository;

  ChatroomRepository(
      {required this.firebaseFirestore, required this.firebaseAuth, required this.userRepository});

  Stream<List<Chatroom>> get chatrooms {
    return firebaseFirestore
        .collection(_ChatroomCollectionPaths.chatrooms)
        .where('participants', arrayContainsAny: [firebaseAuth.currentUser?.uid])
        .orderBy('latestMessageAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.size == 0) {
            return [];
          }

          final userIds = snapshot.docs.map((doc) => doc.data()['participants']).toList();
          final flattenedUserIds = {
            ...[for (var batch in userIds) ...batch].cast<String>()
          }.toList();

          final users = await userRepository.getUsersByIds(flattenedUserIds);

          final userMap = {for (var user in users) user.id: user};

          return snapshot.docs.map((doc) {
            var chatroom = Chatroom.fromJSON(doc.toJSON());

            if (!chatroom.isGroup) {
              final opponentId = chatroom.participants
                  .firstWhere((userId) => userId != firebaseAuth.currentUser?.uid);

              final opponent = userMap[opponentId] ?? User.empty;
              chatroom = chatroom.copyWith(
                  displayName: opponent.displayName, iconUrl: opponent.profileUrl);
            }

            return chatroom;
          }).toList();
        });
  }

  Stream<Chatroom> getChatroomStream(String chatroomId) {
    return firebaseFirestore
        .collection(_ChatroomCollectionPaths.chatrooms)
        .doc(chatroomId)
        .snapshots()
        .asyncMap((doc) async {
      var chatroom = Chatroom.fromJSON(doc.toJSON());

      if (!chatroom.isGroup) {
        final users = await userRepository.getUsersByIds(chatroom.participants);

        final userMap = {for (var user in users) user.id: user};

        final opponentId =
            chatroom.participants.firstWhere((userId) => userId != firebaseAuth.currentUser?.uid);

        final opponent = userMap[opponentId] ?? User.empty;
        chatroom =
            chatroom.copyWith(displayName: opponent.displayName, iconUrl: opponent.profileUrl);
      }

      return chatroom;
    });
  }

  Stream<List<Message>> getMessageStream(String chatroomId) {
    return firebaseFirestore
        .collection(_ChatroomCollectionPaths.getMessagePath(chatroomId))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromJSON(doc.toJSON())).toList());
  }

  Future<String> createChatroom(String opponentId) async {
    final existingRoom = await firebaseFirestore
        .collection(_ChatroomCollectionPaths.chatrooms)
        .where('isGroup', isEqualTo: false)
        .where('participant.$opponentId', isEqualTo: true)
        .where('participant.${firebaseAuth.currentUser?.uid}', isEqualTo: true)
        .limit(1)
        .get();

    if (existingRoom.size > 0) {
      return existingRoom.docs.first.id;
    }

    final doc = await firebaseFirestore.collection(_ChatroomCollectionPaths.chatrooms).add(
        Chatroom.createChatroomPayload(
            userId: firebaseAuth.currentUser!.uid, opponentId: opponentId));

    return doc.id;
  }

  Future<void> createGroup() async {}

  Future<String> sendMessage(String chatroomId, Message message) async {
    final doc = await firebaseFirestore
        .collection(_ChatroomCollectionPaths.getMessagePath(chatroomId))
        .add(message.toJSON());

    return doc.id;
  }

  Future<void> setFileMessageUploaded(String chatroomId, String messageId,
      {required List<String> mediaFiles}) async {
    await firebaseFirestore
        .collection(_ChatroomCollectionPaths.getMessagePath(chatroomId))
        .doc(messageId)
        .update({
      'mediaFiles': mediaFiles,
    });
  }

  Future<void> setFileMessageUploadFailed(
    String chatroomId,
    String messageId,
  ) async {
    await firebaseFirestore
        .collection(_ChatroomCollectionPaths.getMessagePath(chatroomId))
        .doc(messageId)
        .update({
      'status': MessageStatus.error.toString().split('.').last,
    });
  }
}
