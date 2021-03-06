import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:tecky_chat/features/common/models/user.dart';

class _UserCollectionPaths {
  static const users = 'users';
  static getUserPath(String uid) => 'users/$uid';
  static const notificationSettings = 'notificationSettings';
}

class UserRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  UserRepository({required this.firebaseAuth, required this.firebaseFirestore});

  Stream<List<User>> get users {
    return firebaseFirestore
        .collection(_UserCollectionPaths.users)
        .where('id', isNotEqualTo: firebaseAuth.currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => User.fromJSON(doc.data())).toList());
  }

  Future<List<User>> getUsersByIds(List<String> userIds) async {
    final snapshot = await firebaseFirestore
        .collection(_UserCollectionPaths.users)
        .where('id', whereIn: userIds)
        .get();

    return snapshot.docs.map((doc) => User.fromJSON(doc.data())).toList();
  }

  Future<void> createUser(User currentUser) async {
    await firebaseFirestore
        .collection(_UserCollectionPaths.users)
        .doc(currentUser.id)
        .set(currentUser.toJSON(), SetOptions(merge: true));
  }

  Future<void> updateUser(User currentUser) async {}

  Future<void> upsertNotificationSetting(String token) async {
    await firebaseFirestore.collection(_UserCollectionPaths.notificationSettings).doc(token).set({
      'token': token,
      'userId': firebaseAuth.currentUser!.uid,
      'modifiedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeNotificationSetting(String token) async {
    await firebaseFirestore
        .collection(_UserCollectionPaths.notificationSettings)
        .doc(token)
        .delete();
  }
}
