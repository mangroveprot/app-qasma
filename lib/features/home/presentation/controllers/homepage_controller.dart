import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/manager/appointment_config_manager.dart';
import '../../../../common/manager/appointment_manager.dart';
import '../../../../common/manager/auth_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/utils/menu_items_config.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../common/widgets/modal.dart';
import '../../../../common/widgets/models/modal_option.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../../../appointment/data/models/appointment_model.dart';

class HomePageController {
  // Cubits
  late final AppointmentsCubit _appointmentsCubit;
  late final UserCubit _userCubit;
  late final AppointmentConfigCubit _appointmentConfigCubit;

  // Managers
  late final AppointmentManager _appointmentManager;
  late final UserManager _userManager;
  late final AppointmentConfigManager _appointmentConfigManager;

  Function(String route, {Object? extra})? _navigationCallback;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<AppointmentsCubit>(
          create: (context) => _appointmentsCubit,
        ),
        BlocProvider<UserCubit>(
          create: (context) => _userCubit,
        ),
        BlocProvider<AppointmentConfigCubit>(
          create: (context) => _appointmentConfigCubit,
        ),
      ];

  void initialize({Function(String route, {Object? extra})? onNavigate}) {
    _navigationCallback = onNavigate;
    _initializeManagers();
    _initializeCubits();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _appointmentManager = AppointmentManager();
    _userManager = UserManager();
    _appointmentConfigManager = AppointmentConfigManager();
  }

  void _initializeCubits() {
    _appointmentsCubit = AppointmentsCubit();
    _userCubit = UserCubit();
    _appointmentConfigCubit = AppointmentConfigCubit();
  }

  void _loadInitialData() {
    _loadUserData();
    appoitnmentRefreshData();
    _loadAppointmentConfig();
  }

  void _loadUserData() {
    final userId = SharedPrefs().getString('currentUserId');
    if (userId != null) {
      _userManager.loadUser(userId, _userCubit);
    }
  }

  void _loadAppointmentConfig() {
    _appointmentConfigManager
        .loadAllAppointmentsConfig(_appointmentConfigCubit);
  }

  // ============================================================================
  // PUBLIC METHODS - Called by UI components
  // ============================================================================

  Future<void> appoitnmentRefreshData() async {
    await _appointmentManager.refreshAppointments(_appointmentsCubit);
  }

  Future<void> appointConfigRefreshData() async {
    await _appointmentConfigManager
        .refreshAppointmentsConfig(_appointmentConfigCubit);
  }

  void filterAppointmentsByStatus(String status) {
    _appointmentManager.filterByStatus(status, _appointmentsCubit);
  }

  void searchAppointments(String query) {
    if (query.isEmpty) {
      _appointmentsCubit.clearFilters();
    } else {
      _appointmentsCubit.searchAppointments(query);
    }
  }

  List<ModalOption> generateAppointmentOptions(List<String> categories) {
    try {
      final options = categories
          .map((category) => ModalOption(
                value: category.toLowerCase(),
                title: category,
                subtitle: '',
              ))
          .toList();

      return options;
    } catch (e) {
      return [];
    }
  }

  Future<void> handleCancelAppointment(
      String appointmentId, BuildContext context) async {
    final shouldCancel =
        await _showCancellationConfirmation(context, appointmentId);
    if (!shouldCancel) return;

    final reason = await _showReasonSelection(context, appointmentId);
    if (reason == null) return;

    try {
      await _appointmentManager.cancelAppointment(appointmentId, reason);
      await appoitnmentRefreshData();

      if (context.mounted) {
        AppToast.show(
          message: 'Appointment cancelled successfully',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.show(
          message: 'Failed to cancel appointment',
          type: ToastType.error,
        );
      }
    }
  }

  void handleRescheduleAppointment(String appointmentId) {
    // Find the appointment in the current list
    final appointments = _appointmentsCubit.state;
    AppointmentModel? appointmentToReschedule;

    if (appointments is AppointmentsLoadedState) {
      try {
        appointmentToReschedule = appointments.appointments.firstWhere(
            (appointment) => appointment.appointmentId == appointmentId);
      } catch (e) {
        debugPrint('Appointment not found for rescheduling: $appointmentId');
        return;
      }
    }

    if (appointmentToReschedule != null) {
      _navigationCallback?.call(
        Routes.book_appointment,
        extra: {'appointment': appointmentToReschedule},
      );
    } else {
      debugPrint('Appointment not found for rescheduling: $appointmentId');
    }
  }

  void handleShowHistory() {
    _navigationCallback?.call('/history');
    debugPrint('Show appointment history');
  }

  void handleMenuItemTap(String menuItem, BuildContext context) {
    final handler = _getMenuHandlers(context)[menuItem];
    if (handler != null) {
      handler();
    } else {
      debugPrint('Unknown menu item: $menuItem');
    }
  }

  void handleNotificationTap() {
    _navigationCallback?.call('/notifications');
    debugPrint('Notification bell tapped');
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  Map<String, VoidCallback> _getMenuHandlers(BuildContext context) {
    return {
      MenuKeys.appointments: () => _navigationCallback?.call('/appointments'),
      MenuKeys.myProfile: () => _navigationCallback?.call('/profile'),
      MenuKeys.history: () => _navigationCallback?.call('/history'),
      MenuKeys.privacyPolicy: () => _navigationCallback?.call('/privacy'),
      MenuKeys.termsAndCondition: () => _navigationCallback?.call('/terms'),
      MenuKeys.settings: () => _navigationCallback?.call('/settings'),
      MenuKeys.logout: () => _handleLogout(context), // context is now valid
    };
  }

  Future<bool> _showCancellationConfirmation(
      BuildContext context, String appointmentId) async {
    return await CustomModal.showCenteredModal<bool>(
          context,
          title: 'Are you sure to cancel this appointment?',
          icon: CustomModal.warningIcon(
              iconColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.1),
              size: 58,
              iconSize: 28),
          actions: [
            CustomTextButton(
              onPressed: () async {
                context.pop(true);
              },
              text: 'Yes',
              textColor: context.colors.white,
              fontSize: 14,
              fontWeight: context.weight.medium,
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              borderRadius: context.radii.large,
              width: 100,
              height: 44,
            ),
            ModalUI.secondaryButton(
                text: 'No',
                onPressed: () {
                  context.pop(false);
                }),
          ],
        ) ??
        false;
  }

  Future<String?> _showReasonSelection(
      BuildContext context, String appointmentId) async {
    return await CustomModal.showRadioSelectionModal<String>(
      context,
      options: reasonOptionList,
      title: 'Select Cancellation Reason',
      onConfirm: (String reason) async {
        await _appointmentManager.cancelAppointment(appointmentId, reason);
        return reason;
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await AuthManager.logout(context);
      context.go(Routes.root);
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }

  void dispose() {
    _appointmentsCubit.close();
    _userCubit.close();
    _appointmentConfigCubit.close();
  }
}
