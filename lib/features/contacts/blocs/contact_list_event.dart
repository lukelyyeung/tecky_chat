part of 'contact_list_bloc.dart';

abstract class ContactListEvent {
  const ContactListEvent();
}

class ContactRetrieve extends ContactListEvent {}

class ContactListChange extends ContactListEvent {
  final List<Contact> contacts;

  ContactListChange(this.contacts);
}

class ContactListStartChat extends ContactListEvent {
  final Contact contact;
  final Completer<String>? completer;

  ContactListStartChat(this.contact, {this.completer});
}
