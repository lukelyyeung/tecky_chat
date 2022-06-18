part of 'login_form_cubit.dart';

class LoginFormState {
  final FormStatus formStatus;
  final String? error;

  LoginFormState._({this.formStatus = FormStatus.normal, this.error});

  LoginFormState.initial() : this._();
  LoginFormState.failed(String message) : this._(error: message, formStatus: FormStatus.error);
  LoginFormState.submitting() : this._(error: null, formStatus: FormStatus.submitting);
}
