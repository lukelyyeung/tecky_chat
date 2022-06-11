import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/auth/blocs/auth_bloc.dart';
import 'package:tecky_chat/features/chatroom/screens/chatroom_screen.dart';
import 'package:tecky_chat/features/common/screens/main_tab_screen.dart';
import 'package:tecky_chat/features/common/screens/splash_screen.dart';
import 'package:tecky_chat/theme/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authBloc = AuthBloc();
  MyApp({Key? key}) : super(key: key);

  GoRouter get _router {
    return GoRouter(
      redirect: (state) {
        if (authBloc.isLoggedIn == null) {
          return state.subloc == '/splash' ? null : '/splash?from=${state.subloc}';
        }

        if (authBloc.isLoggedIn == true) {
          return ['/splash', '/login', '/register'].contains(state.subloc)
              ? (state.queryParams['from'] ?? '/')
              : null;
        }

        return state.subloc != '/login' ? '/login' : null;

        // if no need to redirect, return null;

        // if loginState == null, redirect to '/splash?from=${state.subloc}'

        // if loginState == true, redirect to state.queryParameters['from] ?? '/';

        // if loginState == false, redirect to '/login'
      },
      refreshListenable: GoRouterRefreshStream(authBloc.isLoggedInStream),
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/', redirect: (_) => '/main?tab=contacts'),
        GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
        GoRoute(
            path: '/main',
            pageBuilder: (context, state) {
              final tabName = state.queryParams['tab'] ?? 'contacts';
              return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 450),
                  key: state.pageKey,
                  child: MainTabScreen(currentTab: tabName),
                  transitionsBuilder: (context, primaryAnimation, _, child) {
                    final opacity = Tween(begin: 0.2, end: 1.0).animate(
                        CurvedAnimation(parent: primaryAnimation, curve: Curves.easeInOutQuad));

                    final offset = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
                        CurvedAnimation(parent: primaryAnimation, curve: Curves.easeInOutQuad));

                    return SlideTransition(
                        position: offset, child: FadeTransition(opacity: opacity, child: child));
                  });
            }),
        GoRoute(
            path: '/chats/:id',
            builder: (context, state) {
              final username = state.params['id'] as String;
              return ChatroomScreen(title: username);
            }),
        GoRoute(
            path: '/settings/:id',
            builder: (context, state) {
              final title = state.extra as String;
              return Scaffold(
                body: Center(child: Text(title)),
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: ThemeColors.neutralWhite,
                  title: Text(title, style: const TextStyle(color: ThemeColors.neutralActive)),
                  centerTitle: false,
                  // Delay the creation of widget to layout
                  // Provide the latest context
                  leading: Builder(
                    builder: (context) => GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.chevron_left, color: ThemeColors.neutralActive),
                      ),
                    ),
                  ),
                ),
              );
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    authBloc.retrieveLoginState();
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
