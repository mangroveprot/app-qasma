import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/navigation_bar/bottom_navbar.dart';
import '../../common/shell_refresh_scope.dart';
import '../../features/activity_logs/presentation/pages/activity_logs_page.dart';
import '../../features/appointment/presentation/pages/book_appointment_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/notifications/presentation/bloc/notification_count_cubit.dart';
import '../../common/presentation/widgets/not_found_page.dart';
import '../../common/utils/app_navigation_config.dart';
import '../../features/appointment/presentation/pages/appointment_history_page.dart';
import '../../features/auth/presentation/pages/change_password.dart';
import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/get_started_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/preferences/presentation/pages/about_page.dart';
import '../../features/preferences/presentation/pages/help_and_support_page.dart';
import '../../features/preferences/presentation/pages/menu_page.dart';
import '../../features/preferences/presentation/pages/settings_page.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/users/presentation/pages/activation_page.dart';
import '../../features/users/presentation/pages/my_profile_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static Widget _getPageForRoute(String route) {
    switch (route) {
      case Routes.home_path:
        return const HomePage();
      case Routes.appointment_history:
        return const AppointmentHistory();
      case Routes.notifications:
        return const NotificationsPage();
      case Routes.menu_path:
        return const MenuPage();
      default:
        return const HomePage();
    }
  }

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
        path: Routes.activation_path,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ActivationPage(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Routes.aut_path,
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
            path: Routes.reset_password,
            builder: (context, state) => const ResetPassswordPage(),
          ),
          GoRoute(
            parentNavigatorKey: parentNavigatorKey,
            path: Routes.change_password,
            builder: (context, state) => const ChangePassswordPage(),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Routes.user_path,
        builder: (context, state) => const MyProfilePage(),
        routes: [
          GoRoute(
            parentNavigatorKey: parentNavigatorKey,
            path: Routes.user_profile,
            builder: (context, state) => const MyProfilePage(),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Routes.preference_path,
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            parentNavigatorKey: parentNavigatorKey,
            path: Routes.about,
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            parentNavigatorKey: parentNavigatorKey,
            path: Routes.helpAndSupport,
            builder: (context, state) => const HelpAndSupport(),
          ),
          GoRoute(
            parentNavigatorKey: parentNavigatorKey,
            path: Routes.activityLogs,
            builder: (context, state) => const ActivityLogsPage(),
          ),
        ],
      ),

      // standalone
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Routes.appointment,
        builder: (context, state) => const BookAppointmentPage(),
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Routes.forgot_password,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: Routes.otp_verification,
        builder: (context, state) => const OtpVerificationPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final currentRoute = state.location.split('?').first;
          return ShellRefreshScope(
            child: BlocBuilder<NotificationCountCubit, int>(
              builder: (context, unreadCount) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: navigationShell,
                  bottomNavigationBar: BottomNavbar(
                    currentRoute: currentRoute,
                    unreadNotificationCount: unreadCount,
                    onTap: (index) {
                      final item = AppNavigationConfig.bottomNavItems[index];

                      if (item.isSpecialButton) return;

                      final branchIndex = AppNavigationConfig.bottomNavItems
                          .take(index)
                          .where((item) => !item.isSpecialButton)
                          .length;

                      navigationShell.goBranch(
                        branchIndex,
                        initialLocation:
                            branchIndex == navigationShell.currentIndex,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        branches: AppNavigationConfig.bottomNavItems
            .where((item) => !item.isSpecialButton)
            .map((item) => StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: item.routeName,
                      pageBuilder: (context, state) => NoTransitionPage(
                        child: _getPageForRoute(item.routeName),
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
