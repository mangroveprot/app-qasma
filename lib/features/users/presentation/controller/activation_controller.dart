import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/modal.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/manager/auth_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../../theme/theme_extensions.dart';
import '../../data/models/user_model.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_cubit_extension.dart';

class ActivationController {
  final UserCubit _userCubit;
  final ButtonCubit _buttonCubit;

  final UserManager _userManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ActivationController()
      : _userManager = UserManager(),
        _buttonCubit = ButtonCubit(),
        _userCubit = UserCubit();

  List<BlocProvider> get blocProviders => [
        BlocProvider<UserCubit>(
          create: (context) => _userCubit,
        ),
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
      ];

  void initialize({
    required BuildContext context,
  }) {
    if (_isInitialized) return;

    _loadInitialData(context);
    _isInitialized = true;
  }

  void _loadInitialData(BuildContext context) {
    _loadUserData();
  }

  void _loadUserData() {
    _userManager.refreshUser(_userCubit);
  }

  UserModel? getUserByIdNumber(String idNumber) {
    return _userCubit.getUserByIdNumber(idNumber);
  }

  String get currentUserId => SharedPrefs().getString('currentUserId') ?? '';
  ButtonCubit get buttonCubit => _buttonCubit;

  UserModel? currentUserProfile() {
    if (currentUserId.isEmpty) return null;
    return _userCubit.getUserByIdNumber(currentUserId);
  }

  Future<void> handleLogout(BuildContext context) async {
    final shouldLogout = await _showLogoutConfirmation(context);
    if (!shouldLogout) return;
    await _performLogout(context);
  }

  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    final colors = context.colors;
    final radii = context.radii;
    final fontWeight = context.weight;

    return await CustomModal.showCenteredModal<bool>(
          context,
          title: 'Are you sure to logout?',
          icon: CustomModal.warningIcon(
            iconColor: colors.error,
            backgroundColor: colors.error.withOpacity(0.1),
            size: 58,
            iconSize: 28,
          ),
          actions: [
            CustomTextButton(
              onPressed: () async {
                context.pop(true);
              },
              text: 'Yes',
              textColor: colors.white,
              fontSize: 14,
              fontWeight: fontWeight.medium,
              backgroundColor: colors.error,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              borderRadius: radii.large,
              width: 100,
              height: 44,
            ),
            ModalUI.secondaryButton(
              text: 'No',
              onPressed: () {
                context.pop(false);
              },
            ),
          ],
        ) ??
        false;
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      await AuthManager.logout(context);
      context.go(Routes.root);
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }
}
