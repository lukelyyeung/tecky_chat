import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/contacts/models/contact.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactState.initial()) {
    on<ContactRetrieve>(_onContactRetrieve);
  }

  Future<void> _onContactRetrieve(ContactRetrieve event, Emitter emit) async {
    emit(ContactState.loading());
    await Future.delayed(const Duration(seconds: 2));
    emit(ContactState.loaded([
      Contact(username: 'Luke Yeung', id: 'luke'),
      Contact(username: 'Alex Lau', id: 'alex'),
      Contact(username: 'Gordan Lau', id: 'gordan'),
      Contact(username: 'Michael Fung', id: 'michael'),
    ]));
  }
}
