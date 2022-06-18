part of 'register_form_cubit.dart';

class RegisterFormState {
  final FormStatus formStatus;
  final String? error;

  RegisterFormState._({this.formStatus = FormStatus.normal, this.error});

  RegisterFormState.initial() : this._();
  RegisterFormState.failed(String message) : this._(error: message, formStatus: FormStatus.error);
  RegisterFormState.submitting() : this._(error: null, formStatus: FormStatus.submitting);
}
