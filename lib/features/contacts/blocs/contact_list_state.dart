part of 'contact_list_bloc.dart';

enum ContactListStatus {
  loading,
  notLoaded,
  error,
  loaded,
}

class ContactListState {
  final List<Contact> contacts;
  final ContactListStatus contactListStatus;

  bool get isLoading => contactListStatus == ContactListStatus.loading;

  ContactListState._({this.contacts = const [], this.contactListStatus = ContactListStatus.notLoaded});
  ContactListState.initial() : this._();
  ContactListState.loading() : this._(contactListStatus: ContactListStatus.loading);
  ContactListState.loaded(List<Contact> contacts)
      : this._(
          contactListStatus: ContactListStatus.loaded,
          contacts: contacts,
        );
}
