import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/common/models/user.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final FirebaseMessaging firebaseMessaging;
  late final StreamSubscription<User> _authStatusSubscription;

  NotificationBloc({
    required this.authRepository,
    required this.firebaseMessaging,
    required this.userRepository,
  }) : super(const NotificationState.initial()) {
    on<NotificationTokenChange>(_onNotificationTokenChange);
    _listenToAuthStatusChange();
  }

  void _listenToAuthStatusChange() {
    _authStatusSubscription = authRepository.currentUserStream.listen((user) async {
      if (user != User.empty) {
        final token = await firebaseMessaging.getToken();

        if (token == null) {
          return;
        }

        await userRepository.upsertNotificationSetting(token);
        add(NotificationTokenChange(token));
      } else {
        if (state.token != null) {
          await userRepository.removeNotificationSetting(state.token!);
        }

        add(NotificationTokenChange(null));
      }
    });
  }

  void _onNotificationTokenChange(NotificationTokenChange event, Emitter emit) async {
    emit(event.token != null
        ? NotificationState.loaded(event.token!)
        : const NotificationState.initial());
  }
}
