import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/get_started_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/test_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    navigatorKey: parentNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: Routes.root,
    routes: [
      GoRoute(path: Routes.root, builder: (context, state) => const HomePage()),
      GoRoute(
        path: Routes.aut_path, // '/auth'
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: Routes.login,
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: Routes.get_started,
            builder: (context, state) => const GetStartedPage(),
          ),
          GoRoute(
            path: Routes.create_account,
            builder: (context, state) => const CreateAccountPage(),
          ),
          GoRoute(
            path: Routes.otp_verification,
            builder: (context, state) => const OtpVerificationPage(),
          ),
          GoRoute(
            path: Routes.forgot_password,
            builder: (context, state) => const ForgotPasswordPage(),
          ),
          GoRoute(path: 'test', builder: (context, state) => const TestPage()),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
