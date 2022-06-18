import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:tecky_chat/features/common/models/user.dart';

part 'auth_repository_errors.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepository({required this.firebaseAuth});

  Stream<User> get currentUserStream {
    return firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return User.empty;
      }

      return User(
          displayName: firebaseUser.displayName ?? firebaseUser.email ?? '',
          id: firebaseUser.uid,
          profileUrl: firebaseUser.photoURL);
    });
  }

  Future<void> logInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordException.fromCode(e.code);
    } catch (e) {
      throw LogInWithEmailAndPasswordException(e.toString());
    }
  }

  Future<void> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw RegisterWithEmailAndPasswordException.fromCode(e.code);
    } catch (e) {
      throw RegisterWithEmailAndPasswordException(e.toString());
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
