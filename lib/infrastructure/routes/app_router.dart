import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../common/presentation/widgets/not_found_page.dart';
import '../../features/appointment/presentation/pages/appointment_history_page.dart';
import '../../features/appointment/presentation/pages/book_appointment_page.dart';
import '../../features/auth/presentation/pages/change_password.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/get_started_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/preferences/presentation/pages/about_page.dart';
import '../../features/preferences/presentation/pages/help_and_support_page.dart';
import '../../features/preferences/presentation/pages/settings_page.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/users/presentation/pages/my_profile_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    navigatorKey: parentNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: Routes.root,
    errorBuilder: (context, state) => const NotFoundPage(),
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
          GoRoute(
            path: Routes.reset_password,
            builder: (context, state) => const ResetPassswordPage(),
          ),
          GoRoute(
            path: Routes.change_password,
            builder: (context, state) => const ChangePassswordPage(),
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
        path: Routes.appointment, // book-appointment
        builder: (context, state) => const BookAppointmentPage(),
        routes: [
          GoRoute(
            path: Routes.appointment_history,
            builder: (context, state) => const AppointmentHistory(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.user_path, // user
        builder: (context, state) => const MyProfilePage(),
        routes: [
          GoRoute(
            path: Routes.user_profile,
            builder: (context, state) => const MyProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.preference_path, // preference
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: Routes.about,
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: Routes.helpAndSupport,
            builder: (context, state) => const HelpAndSupport(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.notifications, // notifcations
        builder: (context, state) => const NotificationsPage(),
        routes: [],
      )
    ],
  );

  static GoRouter get router => _router;
}
