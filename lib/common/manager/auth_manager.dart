import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/_base/_services/storage/shared_preference.dart';
import '../../infrastructure/routes/app_routes.dart';

class AuthManager {
  Future<void> logout(BuildContext context) async {
    try {
      await SharedPrefs().clearAuthData();
      context.go(Routes.root);
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }
}
