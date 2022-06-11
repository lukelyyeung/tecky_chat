abstract class AuthEvent {}

class AuthRetrieveStatus extends AuthEvent {}

class AuthLogInRequest extends AuthEvent {
  final String email;
  final String password;

  AuthLogInRequest({required this.email, required this.password});
}

class AuthLogOutRequest extends AuthEvent {}

