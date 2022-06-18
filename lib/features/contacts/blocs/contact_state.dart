part of 'contact_bloc.dart';

enum ContactListStatus {
  loading,
  notLoaded,
  error,
  loaded,
}

class ContactState {
  final List<Contact> contacts;
  final ContactListStatus contactListStatus;

  bool get isLoading => contactListStatus == ContactListStatus.loading;

  ContactState._({this.contacts = const [], this.contactListStatus = ContactListStatus.notLoaded});
  ContactState.initial() : this._();
  ContactState.loading() : this._(contactListStatus: ContactListStatus.loading);
  ContactState.loaded(List<Contact> contacts)
      : this._(
          contactListStatus: ContactListStatus.loaded,
          contacts: contacts,
        );
}
