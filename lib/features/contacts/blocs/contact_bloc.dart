import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/common/models/user.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';
import 'package:tecky_chat/features/contacts/models/contact.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final UserRepository userRepository;
  late final StreamSubscription<List<User>> _contactListSubscription;

  ContactBloc({required this.userRepository}) : super(ContactState.initial()) {
    on<ContactRetrieve>(_onContactRetrieve);
    on<ContactListChange>(_onContactListChange);

    _listenToContactList();
  }

  @override
  Future<void> close() async {
    super.close();
    _contactListSubscription.cancel();
  }

  _listenToContactList() {
    _contactListSubscription = userRepository.users.listen((users) {
      add(ContactListChange(
          users.map((user) => Contact(id: user.id, username: user.displayName)).toList()));
    });
  }

  void _onContactListChange(ContactListChange event, Emitter emit) {
    emit(ContactState.loaded(event.contacts));
  }

  Future<void> _onContactRetrieve(ContactRetrieve event, Emitter emit) async {
    // emit(ContactState.loading());
    // await Future.delayed(const Duration(seconds: 2));
    // emit(ContactState.loaded([
    //   Contact(username: 'Luke Yeung', id: 'luke'),
    //   Contact(username: 'Alex Lau', id: 'alex'),
    //   Contact(username: 'Gordan Lau', id: 'gordan'),
    //   Contact(username: 'Michael Fung', id: 'michael'),
    // ]));
  }
}
