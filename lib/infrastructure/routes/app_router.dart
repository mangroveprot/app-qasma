import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/get_started_page.dart';
import '../../features/auth/presentation/pages/test_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    navigatorKey: parentNavigatorKey,
    debugLogDiagnostics: true,

    initialLocation: '/',

    routes: [
      GoRoute(path: '/', builder: (context, state) => GetStartedPage()),

      GoRoute(
        path: Routes.aut_path, // '/auth'
        builder: (context, state) => GetStartedPage(),
        routes: [
          GoRoute(
            path: Routes.get_started,
            builder: (context, state) => GetStartedPage(),
          ),
          GoRoute(
            path: Routes.create_account,
            builder: (context, state) => CreateAccountPage(),
          ),
          GoRoute(path: 'test', builder: (context, state) => const TestPage()),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
