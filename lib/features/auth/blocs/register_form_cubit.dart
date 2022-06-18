import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';

part 'register_form_state.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  final AuthRepository authRepository;

  RegisterFormCubit({required this.authRepository}) : super(RegisterFormState.initial());

  submitRegisterForm({required String email, required String password}) async {
    try {
      emit(RegisterFormState.submitting());
      await authRepository.registerWithEmailAndPassword(email: email, password: password);
      emit(RegisterFormState.initial());
    } on RegisterWithEmailAndPasswordException catch (e) {
      emit(RegisterFormState.failed(e.message));
    } catch (e) {
      emit(RegisterFormState.failed('Unknown Error. Please try again.'));
    }
  }
}
