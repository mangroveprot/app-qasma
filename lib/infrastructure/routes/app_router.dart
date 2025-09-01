import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../common/presentation/pages/not_found_page.dart';
import '../../features/appointment/presentation/pages/appointment_history_page.dart';
import '../../features/appointment/presentation/pages/book_appointment_page.dart';
import '../../features/auth/presentation/pages/change_password.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/preferences/presentation/pages/about_page.dart';
import '../../features/preferences/presentation/pages/dashboard_page.dart';
import '../../features/preferences/presentation/pages/privacy_policy_page.dart';
import '../../features/preferences/presentation/pages/settings_page.dart';
import '../../features/preferences/presentation/pages/terms_and_conditions.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/users/presentation/pages/my_profile_page.dart';
import '../../features/users/presentation/pages/profile_setup_page.dart';
import '../../features/users/presentation/pages/users_page.dart';
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
        path: Routes.common, // '/common'
        builder: (context, state) => const ProfileSetupPage(),
        routes: [],
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
        builder: (context, state) => const UsersPage(),
        routes: [
          GoRoute(
            path: Routes.user_profile,
            builder: (context, state) => const MyProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.preference_path, // preference
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            path: Routes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: Routes.privacy_policy,
            builder: (context, state) => const PrivacyPolicyPage(),
          ),
          GoRoute(
            path: Routes.terms_conditons,
            builder: (context, state) => const TermsAndConditionPage(),
          ),
          GoRoute(
            path: Routes.about,
            builder: (context, state) => const AboutPage(),
          ),
        ],
      )
    ],
  );

  static GoRouter get router => _router;
}
