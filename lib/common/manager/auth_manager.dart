import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth/auth_cubit.dart';
import '../../infrastructure/routes/app_router.dart';
import '../../infrastructure/routes/app_routes.dart';
import '../widgets/toast/app_toast.dart';

class AuthManager {
  static bool _isNavigating = false;
  static String? _pendingMessage;

  static Future<void> logout(BuildContext context) async {
    try {
      await AuthCubit.instance.performAutoLogout(reason: 'Logging out...');
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }

  static void handleAuthStateChanges(BuildContext context, AuthState state) {
    if (_isNavigating || !context.mounted) return;

    if (state is AutoLogoutState) {
      _pendingMessage = state.reason;
      _navigateToLogin(context);
    } else if (state is LogoutSuccessState && state.isAutoLogout ||
        state is LogoutFailureState && state.isAutoLogout) {
      _pendingMessage = 'Session expired. Please login again.';
      _navigateToLogin(context);
    }
  }

  static void _navigateToLogin(BuildContext context) {
    _isNavigating = true;

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!context.mounted) return;

      if (_pendingMessage != null) {
        _showLogoutMessage(context, _pendingMessage!);
        _pendingMessage = null;
      }

      try {
        context.go(Routes.root);
      } catch (_) {
        try {
          AppRouter.router.go(Routes.root);
        } catch (e) {
          debugPrint('Navigation fallback failed: $e');
        }
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        AuthCubit.instance.resetToInitial();
        _isNavigating = false;
      });
    });
  }

  static void _showLogoutMessage(BuildContext context, String message) {
    try {
      AppToast.show(
          message: 'You are logging out...', type: ToastType.original);
    } catch (e) {
      debugPrint('Failed to show snackbar: $e');
    }
  }
}
