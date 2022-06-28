import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:tecky_chat/extensions/extended_document_snasphot.dart';
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';

class _ChatroomCollectionPaths {
  static const chatrooms = 'chatrooms';
  static getChatoomPath(String chatroomId) => 'chatrooms/$chatroomId';
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
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.size == 0) {
            return [];
          }

          final userIds = snapshot.docs.map((doc) => doc.data()['participants']).toList();
          final flattenedUserIds = [for (var batch in userIds) ...batch].cast<String>();

          final users = await userRepository.getUsersByIds(flattenedUserIds);

          final userMap = {for (var user in users) user.id: user};

          return snapshot.docs.map((doc) {
            var chatroom = Chatroom.fromJSON(doc.toJSON());

            if (!chatroom.isGroup) {
              final opponentId = chatroom.participants
                  .firstWhere((userId) => userId != firebaseAuth.currentUser?.uid);

              final opponent = userMap[opponentId]!;
              chatroom = chatroom.copyWith(
                  displayName: opponent.displayName, iconUrl: opponent.profileUrl);
            }

            return chatroom;
          }).toList();
        });
  }

  Future<void> createChatroom(String opponentId) async {
    final existingRoom = await firebaseFirestore
        .collection(_ChatroomCollectionPaths.chatrooms)
        .where('isGroup', isEqualTo: false)
        .where('participants', arrayContains: [opponentId, firebaseAuth.currentUser?.uid])
        .limit(1)
        .get();

    if (existingRoom.size > 0) {
      return;
    }

    await firebaseFirestore.collection(_ChatroomCollectionPaths.chatrooms).add({
      "participants": [opponentId, firebaseAuth.currentUser?.uid],
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> createGroup() async {}

  // Stream<List<Message>> getMessageStreamByChatroomId(String chatroomId) {}

  Future<void> sendMessage(Message message) async {}
}
