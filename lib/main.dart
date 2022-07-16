import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tecky_chat/features/auth/blocs/auth_bloc.dart';
import 'package:tecky_chat/features/auth/blocs/auth_state.dart';
import 'package:tecky_chat/features/auth/repositories/auth_repository.dart';
import 'package:tecky_chat/features/auth/screens/login_screen.dart';
import 'package:tecky_chat/features/auth/screens/register_screen.dart';
import 'package:tecky_chat/features/chatroom/blocs/chatroom_list_bloc.dart';
import 'package:tecky_chat/features/chatroom/respositories/chatroom_repository.dart';
import 'package:tecky_chat/features/chatroom/screens/chatroom_screen.dart';
import 'package:tecky_chat/features/common/repositories/user_respository.dart';
import 'package:tecky_chat/features/common/screens/main_tab_screen.dart';
import 'package:tecky_chat/features/common/screens/splash_screen.dart';
import 'package:tecky_chat/features/contacts/blocs/contact_list_bloc.dart';
import 'package:tecky_chat/features/notification/blocs/notification_bloc.dart';
import 'package:tecky_chat/firebase_options.dart';
import 'package:tecky_chat/theme/colors.dart';

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Bloc) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  BlocOverrides.runZoned(
    () => runApp(const AppWithProviders()),
    blocObserver: AppBlocObserver(),
  );
}

class AppWithProviders extends StatelessWidget {
  const AppWithProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseFirestore = FirebaseFirestore.instance;

    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (_) =>
                  UserRepository(firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore)),
          RepositoryProvider(
              create: (ctx) => ChatroomRepository(
                  userRepository: ctx.read<UserRepository>(),
                  firebaseAuth: firebaseAuth,
                  firebaseFirestore: firebaseFirestore)),
          RepositoryProvider(create: (_) => AuthRepository(firebaseAuth: firebaseAuth)),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
              create: (ctx) => AuthBloc(
                  firebaseAuth: firebaseAuth,
                  authRepository: ctx.read<AuthRepository>(),
                  userRepository: ctx.read<UserRepository>())),
          BlocProvider(
              create: (ctx) =>
                  ChatroomListBloc(chatroomRepository: ctx.read<ChatroomRepository>())),
          BlocProvider(
              create: (ctx) => ContactListBloc(
                  chatroomRepository: ctx.read<ChatroomRepository>(),
                  userRepository: ctx.read<UserRepository>())),
          BlocProvider(
              lazy: false,
              create: (ctx) => NotificationBloc(
                  firebaseMessaging: FirebaseMessaging.instance,
                  authRepository: ctx.read<AuthRepository>(),
                  userRepository: ctx.read<UserRepository>()))
        ], child: const MyApp()));
  }
}

class MyApp extends StatefulWidget {
  // final authBloc = AuthBloc();
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) => print('FCM token:$value'));

    super.initState();

    final authBloc = context.read<AuthBloc>();
    _router = GoRouter(
      redirect: (state) {
        if (authBloc.state.status == AuthStatus.unknown) {
          return state.subloc == '/splash' ? null : '/splash?from=${state.subloc}';
        }

        if (authBloc.state.isAuthenticated) {
          return ['/splash', '/login', '/register'].contains(state.subloc)
              ? (state.queryParams['from'] ?? '/')
              : null;
        }

        if (['/login', '/register'].contains(state.subloc)) {
          return null;
        }

        return '/login';

        // if no need to redirect, return null;

        // if loginState == null, redirect to '/splash?from=${state.subloc}'

        // if loginState == true, redirect to state.queryParameters['from] ?? '/';

        // if loginState == false, redirect to '/login'
      },
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/', redirect: (_) => '/main?tab=contacts'),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
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
              final chatroomId = state.params['id'] as String;
              return ChatroomScreen(chatroomId: chatroomId);
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
