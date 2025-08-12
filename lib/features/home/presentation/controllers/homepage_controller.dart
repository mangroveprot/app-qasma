import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/manager/appointment_config_manager.dart';
import '../../../../common/manager/appointment_manager.dart';
import '../../../../common/manager/auth_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/utils/menu_items_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../common/widgets/modal.dart';
import '../../../../common/widgets/models/modal_option.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../appointment/data/models/cancellation_model.dart';
import '../../../appointment/data/models/params/cancel_params.dart';
import '../../../appointment/domain/usecases/cancel_appointment_usecase.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../../../appointment/data/models/appointment_model.dart';

class HomePageController {
  // Cubits
  late final AppointmentsCubit _appointmentsCubit;
  late final UserCubit _userCubit;
  late final AppointmentConfigCubit _appointmentConfigCubit;
  late final ButtonCubit _buttonCubit;

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
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
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
    _buttonCubit = ButtonCubit();
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

  Future<void> userRefreshData() async {
    await _userManager.refreshUser(_userCubit);
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
    final currentUserId = SharedPrefs().getString('currentUserId');
    final shouldCancel =
        await _showCancellationConfirmation(context, appointmentId);
    if (!shouldCancel) return;

    await CustomModal.showRadioSelectionModal<String>(
      context,
      options: reasonOptionList,
      title: 'Select Cancellation Reason',
      onConfirm: (String reason) async {
        final _cancellationData = CancelParams(
            appointmentId: appointmentId,
            cancellation: CancellationModel(
              cancelledAt: DateTime.now(),
              cancelledById: currentUserId,
              reason: reason,
            ));

        await context.read<ButtonCubit>().execute(
              usecase: sl<CancelAppointmentUsecase>(),
              params: _cancellationData,
            );
        return '';
      },
    );
  }

  void handleRescheduleAppointment(String appointmentId) {
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
        Routes.appointment,
        extra: {
          'appointment': appointmentToReschedule,
          'onSuccess': () async {
            await appoitnmentRefreshData();
          },
        },
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
      MenuKeys.myProfile: () => handleMyProfile(),
      MenuKeys.history: () => _navigationCallback?.call(
            Routes.buildPath(Routes.appointment, Routes.appointment_history),
          ),
      MenuKeys.privacyPolicy: () => _navigationCallback?.call('/privacy'),
      MenuKeys.termsAndCondition: () => _navigationCallback?.call('/terms'),
      MenuKeys.settings: () => _navigationCallback?.call('/settings'),
      MenuKeys.logout: () => _handleLogout(context), // context is now valid
    };
  }

  // ============================================================================
  // Modals
  // ============================================================================

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
              iconSize: 28),
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
                }),
          ],
        ) ??
        false;
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await _showLogoutConfirmation(context);
    if (!shouldLogout) return;
    await _peformLogout(context);
  }

  Future<void> _peformLogout(BuildContext context) async {
    try {
      await AuthManager.logout(context);
      context.go(Routes.root);
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }

  void handleBookNewAppointment(String category) {
    _navigationCallback?.call(
      Routes.appointment,
      extra: {
        'category': category,
        'onSuccess': () async {
          await appoitnmentRefreshData();
        },
      },
    );
  }

  void handleMyProfile() {
    _navigationCallback?.call(
      Routes.buildPath(Routes.user_path, Routes.user_profile),
      extra: {
        'onSuccess': () async {
          await userRefreshData();
        },
      },
    );
  }
}
