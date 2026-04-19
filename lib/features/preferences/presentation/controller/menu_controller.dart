import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/manager/auth_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/utils/menu_items_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../common/widgets/modal.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../home/presentation/widgets/home_widget/_feedback/feedback_section.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../../../users/presentation/bloc/user_cubit_extension.dart';

class AppMenuController {
  final UserManager _userManager;
  final UserCubit _userCubit;
  final ButtonCubit _buttonCubit;

  AppMenuController()
      : _userManager = UserManager(),
        _userCubit = UserCubit(),
        _buttonCubit = ButtonCubit();

  List<BlocProvider> get blocProviders => [
        BlocProvider<UserCubit>(
          create: (_) => _userCubit,
        ),
        BlocProvider<ButtonCubit>(
          create: (_) => _buttonCubit,
        ),
      ];

  UserCubit get userCubit => _userCubit;

  void initialize() {
    final currentUserId = SharedPrefs().getString('currentUserId') ?? '';
    if (currentUserId.isNotEmpty) {
      _userManager.loadUser(currentUserId, _userCubit);
    }
  }

  String get currentUserId => SharedPrefs().getString('currentUserId') ?? '';

  ButtonCubit get buttonCubit => _buttonCubit;

  UserModel? currentUserProfile() {
    if (currentUserId.isEmpty) return null;
    return _userCubit.getUserByIdNumber(currentUserId);
  }

  void handleMenuItemTap(BuildContext context, String menuKey) {
    switch (menuKey) {
      case MenuKeys.myProfile:
        context.push(
          Routes.buildPath(Routes.user_path, Routes.user_profile),
        );
        break;
      case MenuKeys.settings:
        context.push(Routes.preference_path);
        break;
      case MenuKeys.about:
        context.push(
          Routes.buildPath(Routes.preference_path, Routes.about),
        );
        break;
      case MenuKeys.helpAndSupport:
        context.push(
          Routes.buildPath(Routes.preference_path, Routes.helpAndSupport),
        );
        break;
      case MenuKeys.feedback:
        _handleMenuFeedback(context);
        break;
      case MenuKeys.logout:
        _handleLogout(context);
        break;
      default:
        debugPrint('Unknown menu item: $menuKey');
    }
  }

  void _handleMenuFeedback(BuildContext context) {
    menuFeedback(context);
  }

  void menuFeedback(BuildContext context) {
    final feedBackSection = FeedBackSection(
      context: context,
      buttonCubit: buttonCubit,
    );
    feedBackSection.showGeneralFeedback();
  }

  Future<void> _handleLogout(BuildContext context) async {
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
