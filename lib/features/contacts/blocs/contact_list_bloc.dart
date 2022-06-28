import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/common/models/user.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';
import 'package:tecky_chat/features/contacts/models/contact.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final UserRepository userRepository;
  late final StreamSubscription<List<User>> _contactListSubscription;

  ContactListBloc({required this.userRepository}) : super(ContactListState.initial()) {
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
    emit(ContactListState.loaded(event.contacts));
  }
}
