part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class NotificationTokenChange extends NotificationEvent {
  final String? token;

  NotificationTokenChange(this.token);
}

class NotificationOnMessageReceived extends NotificationEvent {
  final RemoteMessage message;
  NotificationOnMessageReceived(this.message);
}
