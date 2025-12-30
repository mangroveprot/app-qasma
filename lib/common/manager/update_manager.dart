import 'package:flutter/material.dart';

import '../../core/_config/app_config.dart';
import '../../features/update/presentation/bloc/update_cubit.dart';
import '../../features/update/presentation/widget/update_modal.dart';
import '../../infrastructure/routes/app_router.dart';

class UpdateManager {
  static bool _isShowingDialog = false;

  static final String _officialWebsiteUrl = AppConfig.webUrl;

  static void handleUpdateStateChanges(
    BuildContext context,
    UpdateCubitState state, {
    bool isManualCheck = false,
  }) {
    if (_isShowingDialog) return;

    if (state is UpdateAvailable) {
      _showUpdateDialog(state);
    } else if (state is UpdateNotAvailable && isManualCheck) {
      _showNoUpdateDialog(state);
    }
  }

  static void _showUpdateDialog(UpdateAvailable state) {
    _isShowingDialog = true;

    final navContext =
        AppRouter.router.routerDelegate.navigatorKey.currentContext;

    if (navContext != null && navContext.mounted) {
      UpdateDialog.show(
        context: navContext,
        currentVersion: state.currentVersion ?? '1.0.0',
        currentBuild: state.currentBuild ?? '1',
        latestRelease: state.latestRelease,
        officialWebsiteUrl: _officialWebsiteUrl,
      ).then((_) {
        _isShowingDialog = false;
      });
    } else {
      _isShowingDialog = false;
    }
  }

  static void _showNoUpdateDialog(UpdateNotAvailable state) {
    _isShowingDialog = true;

    final navContext =
        AppRouter.router.routerDelegate.navigatorKey.currentContext;

    if (navContext != null && navContext.mounted) {
      UpdateDialog.showNoUpdateAvailable(
        context: navContext,
        currentVersion: state.currentVersion ?? '1.0.0',
        currentBuild: state.currentBuild ?? '1',
      ).then((_) {
        _isShowingDialog = false;
      });
    } else {
      _isShowingDialog = false;
    }
  }

  void reset() {
    _isShowingDialog = false;
  }
}
