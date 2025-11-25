import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/manager/appointment_config_manager.dart';
import '../../../../common/manager/appointment_manager.dart';
import '../../../../common/manager/auth_manager.dart';
import '../../../../common/manager/notificaitons_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/utils/menu_items_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/custom_modal/_radio/animated_radio_content.dart';
import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../common/widgets/modal.dart';
import '../../../../common/widgets/models/modal_option.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
import '../../../appointment/data/models/cancellation_model.dart';
import '../../../appointment/data/models/params/approved_params.dart';
import '../../../appointment/data/models/params/availability_params.dart';
import '../../../appointment/data/models/params/cancel_params.dart';
import '../../../appointment/domain/usecases/approved_appointment_usecase.dart';
import '../../../appointment/domain/usecases/cancel_appointment_usecase.dart';
import '../../../appointment/domain/usecases/counselors_availability_usecase.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../../../appointment/data/models/appointment_model.dart';
import '../../../users/presentation/bloc/user_cubit_extensions.dart';

class HomePageController {
  // Cubits
  late final AppointmentsCubit _appointmentsCubit;
  late final UserCubit _userCubit;
  late final AppointmentConfigCubit _appointmentConfigCubit;
  late final ButtonCubit _buttonCubit;
  late final NotificationsCubit _notificationCubit;

  // Managers
  late final AppointmentManager _appointmentManager;
  late final UserManager _userManager;
  late final AppointmentConfigManager _appointmentConfigManager;
  late final NotificationsManager _notificationsManager;

  Function(String route, {Object? extra})? _navigationCallback;

  int _unreadCount = 0;
  int get unreadCount {
    return _unreadCount;
  }

  VoidCallback? _onUnreadCountChanged;

  void setUnreadCountCallback(VoidCallback callback) {
    _onUnreadCountChanged = callback;
  }

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider>? _blocProviders;

  List<BlocProvider> get blocProviders {
    if (_blocProviders == null) {
      throw StateError(
          'Controller must be initialized before accessing blocProviders');
    }
    return _blocProviders!;
  }

  void initialize({Function(String route, {Object? extra})? onNavigate}) {
    _navigationCallback = onNavigate;
    _initializeManagers();
    _initializeCubits();
    _createBlocProviders();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _appointmentManager = AppointmentManager();
    _userManager = UserManager();
    _appointmentConfigManager = AppointmentConfigManager();
    _notificationsManager = NotificationsManager();
  }

  void _initializeCubits() {
    _appointmentsCubit = AppointmentsCubit();
    _userCubit = UserCubit();
    _appointmentConfigCubit = AppointmentConfigCubit();
    _buttonCubit = ButtonCubit();
    _notificationCubit = NotificationsCubit();
  }

  void _createBlocProviders() {
    _blocProviders = [
      BlocProvider<AppointmentsCubit>.value(value: _appointmentsCubit),
      BlocProvider<UserCubit>.value(value: _userCubit),
      BlocProvider<AppointmentConfigCubit>.value(
          value: _appointmentConfigCubit),
      BlocProvider<ButtonCubit>.value(value: _buttonCubit),
      BlocProvider<NotificationsCubit>(
        create: (context) => _notificationCubit,
      ),
    ];
  }

  void _loadInitialData() {
    _loadUserData();
    appoitnmentRefreshData();
    _loadAppointmentConfig();
    _loadNotificationsData();
  }

  void _loadUserData() {
    _userManager.loadAllUser(_userCubit);
  }

  void _loadAppointmentConfig() {
    _appointmentConfigManager
        .loadAllAppointmentsConfig(_appointmentConfigCubit);
  }

  void _loadNotificationsData() {
    _notificationsManager.refreshNotifications(_notificationCubit);
    _notificationsManager.getUnreadCounts().then((count) {
      _unreadCount = count;
      _onUnreadCountChanged?.call();
    });
  }

  // PUBLIC METHODS

  AppointmentManager get appointmentManager => _appointmentManager;

  String get currentUserId => SharedPrefs().getString('currentUserId') ?? '';

  Future<void> appoitnmentRefreshData() async {
    await _appointmentManager.refreshAppointments(_appointmentsCubit);
    await _notificationsManager.refreshNotifications(_notificationCubit);
    _unreadCount = await _notificationsManager.getUnreadCounts();
    _onUnreadCountChanged?.call();
  }

  UserModel? getUserByIdNumber(String idNumber) {
    return _userCubit.getUserByIdNumber(idNumber);
  }

  UserModel? currentUserProfile() {
    if (currentUserId.isEmpty) return null;
    return _userCubit.getUserByIdNumber(currentUserId);
  }

  Future<void> userRefreshData() async {
    await _userManager.refreshUser(_userCubit);
  }

  Future<void> appointConfigRefreshData() async {
    await _appointmentConfigManager
        .refreshAppointmentsConfig(_appointmentConfigCubit);
  }

  Future<void> notificationsRefreshData() async {
    await _notificationsManager.refreshNotifications(_notificationCubit);
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

  // Handler
  Future<void> handleApprovedAppointment(
    BuildContext context,
    String appointmentId,
  ) async {
    final currentUserId = SharedPrefs().getString('currentUserId') ?? 'staff';
    final appointments = _appointmentsCubit.state;
    AppointmentModel? appointmentsToApprove;
    if (appointments is AppointmentsLoadedState) {
      try {
        appointmentsToApprove = appointments.appointments.firstWhere(
            (appointment) => appointment.appointmentId == appointmentId);

        final List<Map<String, dynamic>> gettingListOfCounselors =
            await _getCounselorsAvailability(
          context: context,
          model: appointmentsToApprove,
        );

        final List<ModalOption> counselorOptions =
            gettingListOfCounselors.map((item) {
          return ModalOption(
            value: item['id'],
            title: '',
            subtitle: item['name'],
            icon:
                Icon(Icons.person, size: 14, color: context.colors.textPrimary),
          );
        }).toList();

        await CustomModal.showRadioSelectionModal<String>(
          context,
          buttonId: 'counselor_selection_approved_${appointmentId}',
          isBottomSheet: false,
          options: counselorOptions,
          title: 'Select a counselor to assign',
          subtitle: 'Only available counselors are shown below',
          selectedOptionType: SelectedOptionType.value,
          onConfirm: (String value) async {
            final _approvedData = ApprovedParams(
              studentId: appointmentsToApprove!.studentId,
              staffId: currentUserId,
              counselorId: value,
              appointmentId: appointmentId,
              status: StatusType.approved.field,
            );

            await context.read<ButtonCubit>().execute(
                  buttonId: 'counselor_selection_approved_${appointmentId}',
                  usecase: sl<ApprovedAppointmentUsecase>(),
                  params: _approvedData,
                );
            AppToast.show(
              message: 'Appointment has been approved successfully.',
              type: ToastType.success,
            );
            return '';
          },
        );
      } catch (e) {
        debugPrint('Appointment not found for approving: $appointmentId');
        return;
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getCounselorsAvailability({
    required BuildContext context,
    required AppointmentModel model,
  }) async {
    final _availabilityReq = AvailabilityParams(
      scheduledStartAt: model.scheduledStartAt,
      scheduledEndAt: model.scheduledEndAt,
    );

    final cubit = context.read<ButtonCubit>();
    cubit.emitLoading(buttonId: 'approved${model.appointmentId}');

    final usecase = sl<CounselorsAvailabilityUsecase>();
    final result = await usecase.call(param: _availabilityReq);

    return result.fold(
      (failure) {
        cubit.emitError(errorMessages: [failure]);
        return <Map<String, dynamic>>[];
      },
      (data) {
        cubit.emitInitial();
        return data as List<Map<String, dynamic>>;
      },
    );
  }

  Future<void> handleCancelAppointment(
    String appointmentId,
    BuildContext context,
  ) async {
    final currentUserId = SharedPrefs().getString('currentUserId');
    final shouldCancel =
        await _showCancellationConfirmation(context, appointmentId);
    if (!shouldCancel) return;

    await CustomModal.showRadioSelectionModal<String>(
      context,
      buttonId: 'counselor_selection_canceled_${appointmentId}',
      isBottomSheet: false,
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
              buttonId: 'counselor_selection_canceled_${appointmentId}',
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

  // PRIVATE METHODS

  Map<String, VoidCallback> _getMenuHandlers(BuildContext context) {
    return {
      MenuKeys.dashboard: () => _navigationCallback?.call(
            Routes.preference_path,
          ),
      MenuKeys.myProfile: () => handleMyProfile(),
      MenuKeys.history: () => _navigationCallback?.call(
            Routes.buildPath(Routes.appointment, Routes.appointment_history),
          ),
      MenuKeys.users: () => _navigationCallback?.call(
            Routes.user_path,
          ),
      MenuKeys.settings: () => _navigationCallback?.call(Routes.buildPath(
            Routes.preference_path,
            Routes.settings,
          )),
      MenuKeys.about: () => _navigationCallback?.call(Routes.buildPath(
            Routes.preference_path,
            Routes.about,
          )),
      MenuKeys.logout: () => _handleLogout(context),
    };
  }

  // Modals

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

  void handleMyProfile([String? idNumber, bool isCurrentUser = true]) {
    _navigationCallback?.call(
      Routes.buildPath(Routes.user_path, Routes.user_profile),
      extra: {
        'idNumber': idNumber ?? SharedPrefs().getString('currentUserId'),
        'isCurrentUser': isCurrentUser,
        'onSuccess': () async {
          await userRefreshData();
        },
      },
    );
  }

  void handleNotificationTap() {
    _navigationCallback?.call(
      '/notifications',
      extra: {
        'onSuccess': () async {
          _unreadCount = await _notificationsManager.getUnreadCounts();
          _onUnreadCountChanged?.call();
        },
      },
    );
  }
}
