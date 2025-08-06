import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/appointment/presentation/pages/book_appointment_page.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/get_started_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    navigatorKey: parentNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: Routes.root,
    routes: [
      GoRoute(
        path: Routes.root,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: Routes.aut_path, // '/auth'
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: Routes.login,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LoginPage()),
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
        ],
      ),
      // home
      GoRoute(
        path: Routes.home_path, // '/home'
        builder: (context, state) => const HomePage(),
        routes: [],
      ),
      GoRoute(
        path: Routes.book_appointment, // '/book-appointment'
        builder: (context, state) => const BookAppointmentPage(),
        routes: [],
      )
    ],
  );

  static GoRouter get router => _router;
}
