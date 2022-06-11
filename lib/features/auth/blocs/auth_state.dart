import 'package:tecky_chat/features/common/models/user.dart';

enum AuthStatus {
  authenticated,
  notAuthenticated,
  unknown,
}

class AuthState {
  final AuthStatus status;
  final User? user;

  const AuthState._({required this.status, this.user});

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState.authenticated(User user) : this._(status: AuthStatus.authenticated, user: user);
  AuthState.notAuthenticated() : this._(status: AuthStatus.notAuthenticated);
  AuthState.initial() : this._(status: AuthStatus.unknown);

  @override
  String toString() {
    return '{ status: $status, user: $user }';
  }
}
