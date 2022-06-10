import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/chatroom/screens/chatroom_screen.dart';
import 'package:tecky_chat/features/common/screens/main_tab_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  GoRouter get _router {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', redirect: (_) => '/main?tab=contacts'),
        GoRoute(
            path: '/main',
            builder: (context, state) {
              final tabName = state.queryParams['tab'] ?? 'contacts';
              return MainTabScreen(currentTab: tabName);
            }),
        GoRoute(
            path: '/chats/:id',
            builder: (context, state) {
              final username = state.params['id'] as String;
              return ChatroomScreen(title: username);
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
