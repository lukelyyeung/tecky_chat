import 'dart:async';

class AuthBloc {
  final loginState = StreamController<bool?>.broadcast();
  bool? isLoggedIn;

  AuthBloc();

  void retrieveLoginState() async {
    await Future.delayed(const Duration(seconds: 3));
    isLoggedIn = true;
    loginState.sink.add(true);
  }

  dispose() {
    loginState.close();
  }

  Stream<bool?> get isLoggedInStream => loginState.stream;
}