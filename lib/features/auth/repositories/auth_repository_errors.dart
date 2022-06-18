part of 'auth_repository.dart';

class LogInWithEmailAndPasswordException implements Exception {
  final String message;
  final String code;

  const LogInWithEmailAndPasswordException([this.message = 'Unknown Error', this.code = 'unknown']);

  factory LogInWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordException('Invalid Email.', 'invalid-email');
      case 'user-disabled':
        return const LogInWithEmailAndPasswordException(
            'The account has been disabled. Please contact our customer service', 'user-disabled');
      case 'user-not-found':
        return const LogInWithEmailAndPasswordException(
            'This email does not have an account.', 'user-not-found');
      case 'wrong-password':
        return const LogInWithEmailAndPasswordException('Incorrect credential.', 'wrong-password');
      default:
        return const LogInWithEmailAndPasswordException();
    }
  }
}

class RegisterWithEmailAndPasswordException implements Exception {
  final String message;
  final String code;

  const RegisterWithEmailAndPasswordException(
      [this.message = 'Unknown Error', this.code = 'unknown']);

  factory RegisterWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const RegisterWithEmailAndPasswordException('Invalid Email.', 'invalid-email');
      case 'email-already-in-use':
        return const RegisterWithEmailAndPasswordException(
            'The email is already in use.', 'email-already-in-use');
      case 'weak-password':
        return const RegisterWithEmailAndPasswordException(
            'Password does not match the security level. Please try a stronger one.',
            'weak-password');
      default:
        return const RegisterWithEmailAndPasswordException();
    }
  }
}
