import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/_base/_services/storage/shared_preference.dart';
import '../../features/auth/data/models/logout_params.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth/auth_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';
import '../../infrastructure/routes/app_router.dart';
import '../../infrastructure/routes/app_routes.dart';
import '../widgets/toast/app_toast.dart';

class AuthManager {
  static bool _isNavigating = false;
  static String? _pendingMessage;

  static Future<void> logout(BuildContext context) async {
    try {
      final accessToken = SharedPrefs().getString('accessToken');
      final refreshToken = SharedPrefs().getString('refreshToken');
      if (accessToken == null || refreshToken == null) {
        await AuthCubit.instance
            .performAutoLogout(reason: 'Missing session token.');
        return;
      }

      final data =
          LogoutParams(refreshToken: refreshToken, accessToken: accessToken);
      await AuthCubit.instance
          .logout(usecase: sl<LogoutUsecase>(), params: data);
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
    } else if (state is LogoutSuccessState && !state.isAutoLogout) {
      _pendingMessage = 'Logout successfully!';
      _navigateToLogin(context);
    } else if (state is LogoutFailureState) {
      if (state.errorMessages.isNotEmpty) {
        scheduleMicrotask(() {
          AppToast.show(
            message: state.errorMessages.first,
            type: ToastType.error,
          );
        });
      }
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
    AppToast.show(message: message, type: ToastType.original);
  }
}
