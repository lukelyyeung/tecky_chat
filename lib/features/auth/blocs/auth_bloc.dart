import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/auth_event.dart';
import 'package:tecky_chat/features/auth/blocs/auth_state.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/common/models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User> _currentUserSubscription;

  AuthBloc({required this.authRepository}) : super(AuthState.initial()) {
    on<AuthStatusChange>(_onAuthStatusChange);
    on<AuthLogOutRequest>(_onLogOutRequest);
    on<AuthLogInRequest>(_onLogInRequest);

    _listenToCurrentUser();
  }

  @override
  Future<void> close() async {
    super.close();
    _currentUserSubscription.cancel();
  }

  void _listenToCurrentUser() {
    _currentUserSubscription =
        authRepository.currentUserStream.listen((user) => add(AuthStatusChange(user)));
  }

  void _onAuthStatusChange(AuthStatusChange event, Emitter emit) {
    emit(event.user != User.empty
        ? AuthState.authenticated(event.user)
        : AuthState.notAuthenticated());
  }

  void _onLogOutRequest(AuthLogOutRequest event, Emitter emit) {}
  void _onLogInRequest(AuthLogInRequest event, Emitter emit) {}
}
