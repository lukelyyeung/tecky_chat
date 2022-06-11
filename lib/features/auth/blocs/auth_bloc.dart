import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/auth_event.dart';
import 'package:tecky_chat/features/auth/blocs/auth_state.dart';
import 'package:tecky_chat/features/common/models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<AuthRetrieveStatus>(_onAuthRetrieveState);
    on<AuthLogOutRequest>(_onLogOutRequest);
    on<AuthLogInRequest>(_onLogInRequest);
  }

  void _onAuthRetrieveState(AuthRetrieveStatus event, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 3));
    emit(AuthState.authenticated(User(displayName: 'Luke Yeung')));
  }

  void _onLogOutRequest(AuthLogOutRequest event, Emitter emit) {}
  void _onLogInRequest(AuthLogInRequest event, Emitter emit) {}
}
