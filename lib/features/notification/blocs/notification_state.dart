part of 'notification_bloc.dart';

@immutable
class NotificationState {
  final String? token;

  const NotificationState._({this.token});
  const NotificationState.initial() : this._();
  const NotificationState.loaded(String token) : this._(token: token);
}
