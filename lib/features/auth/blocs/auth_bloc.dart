import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tecky_chat/features/auth/blocs/auth_event.dart';
import 'package:tecky_chat/features/auth/blocs/auth_state.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/common/models/user.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final firebase_auth.FirebaseAuth firebaseAuth;
  final UserRepository userRepository;

  late final StreamSubscription<User> _currentUserSubscription;
  late final StreamSubscription<firebase_auth.User?> _firebaseUserSubscription;

  AuthBloc({
    required this.authRepository,
    required this.userRepository,
    required this.firebaseAuth,
  }) : super(AuthState.initial()) {
    on<AuthStatusChange>(_onAuthStatusChange);
    on<AuthLogOutRequest>(_onLogOutRequest);
    on<AuthLogInRequest>(_onLogInRequest);

    _listenToCurrentUser();
    _listenToFirebaseUser();
  }

  @override
  Future<void> close() async {
    super.close();
    _currentUserSubscription.cancel();
    _firebaseUserSubscription.cancel();
  }

  void _listenToCurrentUser() {
    _currentUserSubscription =
        authRepository.currentUserStream.listen((user) => add(AuthStatusChange(user)));
  }

  void _listenToFirebaseUser() {
    _firebaseUserSubscription = firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        return;
      }

      final currentUser = User(
          id: firebaseUser.uid,
          displayName: firebaseUser.displayName ?? firebaseUser.email ?? '',
          profileUrl: firebaseUser.photoURL);

      userRepository.createUser(currentUser);
    });
  }

  void _onAuthStatusChange(AuthStatusChange event, Emitter emit) {
    emit(event.user != User.empty
        ? AuthState.authenticated(event.user)
        : AuthState.notAuthenticated());
  }

  void _onLogOutRequest(AuthLogOutRequest event, Emitter emit) {}
  void _onLogInRequest(AuthLogInRequest event, Emitter emit) {}
}
