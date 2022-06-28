import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';
import 'package:tecky_chat/features/common/models/user.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';
import 'package:tecky_chat/features/contacts/models/contact.dart';

part 'contact_list_event.dart';
part 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final UserRepository userRepository;
  final ChatroomRepository chatroomRepository;
  late final StreamSubscription<List<User>> _contactListSubscription;

  ContactListBloc({required this.userRepository, required this.chatroomRepository})
      : super(ContactListState.initial()) {
    on<ContactListChange>(_onContactListChange);
    on<ContactListStartChat>(_onContactListStartChat);

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

  void _onContactListStartChat(ContactListStartChat event, Emitter emit) async {
    final chatroomId = await chatroomRepository.createChatroom(event.contact.id);
    event.completer?.complete(chatroomId);
  }
}
