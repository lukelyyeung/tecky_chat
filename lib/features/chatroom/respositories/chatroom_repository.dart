import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:tecky_chat/features/chatroom/models/chatroom.dart';
import 'package:tecky_chat/features/chatroom/models/message.dart';
import 'package:tecky_chat/features/common/models/user.dart';

class _ChatroomCollectionPaths {
  static const chatrooms = 'chatrooms';
  static getChatoomPath(String chatroomId) => 'chatrooms/$chatroomId';
}

class ChatroomRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  ChatroomRepository({required this.firebaseFirestore, required this.firebaseAuth});

  Stream<List<Chatroom>> get chatrooms {
    return firebaseFirestore
        .collection(_ChatroomCollectionPaths.chatrooms)
        .where('participants', arrayContainsAny: [firebaseAuth.currentUser?.uid])
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.size == 0) {
            return [];
          }

          final userIds =
              snapshot.docs.map((doc) => doc.data()['participants']).toList();
          final flattenedUserIds = [for (var batch in userIds) ...batch];

          // @TODO: Should do this in UserRepository
          final users = await firebaseFirestore
              .collection('users')
              .where('id', whereIn: flattenedUserIds)
              .get()
              .then((snapshot) => snapshot.docs.map((doc) => User.fromJSON(doc.data())));

          final userMap = {for (var user in users) user.id: user};

          return snapshot.docs.map((doc) {
            final data = doc.data();
            final isGroup = data['isGroup'] ?? false;

            var displayName = '';
            String? iconUrl;

            if (isGroup) {
              displayName = data['displayName'];
              iconUrl = data['iconUrl'];
            } else {
              final opponent = userMap[(data['participants'])
                  .firstWhere((userId) => userId != firebaseAuth.currentUser?.uid)]!;
              displayName = opponent.displayName;
              iconUrl = opponent.profileUrl;
            }

            return Chatroom(
              id: doc.id,
              displayName: displayName,
              iconUrl: iconUrl,
              participants: List.castFrom<dynamic, String>(['participants']),
              isGroup: data['isGroup'] ?? false,
            );
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
