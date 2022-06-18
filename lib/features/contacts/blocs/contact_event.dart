part of 'contact_bloc.dart';

abstract class ContactEvent {
  const ContactEvent();
}

class ContactRetrieve extends ContactEvent {}

class ContactListChange extends ContactEvent {
  final List<Contact> contacts;

  ContactListChange(this.contacts);
}
