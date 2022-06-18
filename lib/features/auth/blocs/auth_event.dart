import 'package:tecky_chat/features/common/models/user.dart';

abstract class AuthEvent {}

// class AuthRetrieveStatus extends AuthEvent {}

class AuthStatusChange extends AuthEvent {
  final User user;

  AuthStatusChange(this.user);
}

class AuthLogInRequest extends AuthEvent {
  final String email;
  final String password;

  AuthLogInRequest({required this.email, required this.password});
}

class AuthLogOutRequest extends AuthEvent {}
