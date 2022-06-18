import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/common/constants/form_status.dart';

part 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  final AuthRepository authRepository;

  LoginFormCubit({required this.authRepository}) : super(LoginFormState.initial());

  submitLoginForm({required String email, required String password}) async {
    try {
      emit(LoginFormState.submitting());
      await authRepository.logInWithEmailAndPassword(email: email, password: password);
      emit(LoginFormState.initial());
    } on LogInWithEmailAndPasswordException catch (e) {
      emit(LoginFormState.failed(e.message));
    } catch (e) {
      emit(LoginFormState.failed('Unknown Error. Please try again.'));
    }
  }
}
