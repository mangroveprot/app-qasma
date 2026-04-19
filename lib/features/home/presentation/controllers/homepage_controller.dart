import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/manager/appointment_config_manager.dart';
import '../../../../common/manager/appointment_manager.dart';
import '../../../../common/manager/notificaitons_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/utils/constant.dart';
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
import '../../../appointment_config/domain/entites/category.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../../../appointment/data/models/appointment_model.dart';
import '../../../users/presentation/bloc/user_cubit_extension.dart';
import '../widgets/home_widget/_feedback/feedback_section.dart';

class HomePageController {
  // Cubits
  final AppointmentsCubit _appointmentsCubit;
  final UserCubit _userCubit;
  final ButtonCubit _buttonCubit;
  final NotificationsCubit _notificationCubit;

  // Managers
  final AppointmentManager _appointmentManager;
  final UserManager _userManager;
  final AppointmentConfigManager _appointmentConfigManager;
  final NotificationsManager _notificationsManager;

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

  HomePageController()
      : _appointmentManager = AppointmentManager(),
        _userManager = UserManager(),
        _appointmentConfigManager = sl<AppointmentConfigManager>(),
        _notificationsManager = NotificationsManager(),
        _appointmentsCubit = AppointmentsCubit(),
        _userCubit = UserCubit(),
        _buttonCubit = ButtonCubit(),
        _notificationCubit = NotificationsCubit();

  List<BlocProvider> get blocProviders => [
        BlocProvider<AppointmentsCubit>(
          create: (context) => _appointmentsCubit,
        ),
        BlocProvider<UserCubit>(
          create: (context) => _userCubit,
        ),
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
        BlocProvider<NotificationsCubit>(
          create: (context) => _notificationCubit,
        ),
      ];

  void initialize({
    Function(String route, {Object? extra})? onNavigate,
    required BuildContext context,
  }) {
    if (_isInitialized) return;

    _navigationCallback = onNavigate;
    _loadInitialData(context);
    _isInitialized = true;
  }

  void _loadInitialData(BuildContext context) {
    _loadUserData();
    appoitnmentRefreshData();
    _loadAppointmentConfig(context);
    _loadNotificationsData();
  }

  void _loadUserData() {
    _userManager.refreshUser(_userCubit);
  }

  void _loadNotificationsData() {
    _notificationsManager.refreshNotifications(_notificationCubit);
    _notificationsManager.getUnreadCounts().then((count) {
      _unreadCount = count;
      _onUnreadCountChanged?.call();
    });
  }

  void _loadAppointmentConfig(BuildContext context) {
    final globalCubit = context.read<AppointmentConfigCubit>();
    _appointmentConfigManager.refreshAppointmentsConfig(globalCubit);
  }

  // PUBLIC METHODS

  ButtonCubit get buttonCubit => _buttonCubit;

  AppointmentManager get appointmentManager => _appointmentManager;

  NotificationsManager get notificationManager => _notificationsManager;

  String get currentUserId => SharedPrefs().getString('currentUserId') ?? '';

  void checkPendingFeedback(BuildContext context) {
    final feedBackSection = FeedBackSection(
      context: context,
      buttonCubit: buttonCubit,
    );
    feedBackSection.checkPendingFeedback();
  }

  void menuFeedback(BuildContext context) {
    final feedBackSection = FeedBackSection(
      context: context,
      buttonCubit: buttonCubit,
    );
    feedBackSection.showGeneralFeedback();
  }

  UserModel? getUserByIdNumber(String idNumber) {
    return _userCubit.getUserByIdNumber(idNumber);
  }

  UserModel? currentUserProfile() {
    if (currentUserId.isEmpty) return null;
    return _userCubit.getUserByIdNumber(currentUserId);
  }

  Future<void> appoitnmentRefreshData() async {
    await _appointmentManager.refreshAppointments(_appointmentsCubit);
    await _notificationsManager.refreshNotifications(_notificationCubit);
    _unreadCount = await _notificationsManager.getUnreadCounts();
    _onUnreadCountChanged?.call();
  }

  Future<void> userRefreshData() async {
    await _userManager.refreshUser(_userCubit);
  }

  Future<void> appointConfigRefreshData(BuildContext context) async {
    final cubit = context.read<AppointmentConfigCubit>();
    await _appointmentConfigManager.refreshAppointmentsConfig(cubit);
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

  List<ModalOption> generateAppointmentOptions(
      Map<String, Category> categories) {
    try {
      final options = categories.entries
          .map((entry) => ModalOption(
                value: entry.key,
                title: entry.key,
                subtitle: entry.value.description ?? 'No description',
              ))
          .toList();

      return options;
    } catch (e) {
      return [];
    }
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
      buttonId: 'selection_canceled_${appointmentId}',
      options: reasonOptionList,
      title: 'Select Cancellation Reason',
      isBottomSheet: true,
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
              buttonId: 'selection_canceled_${appointmentId}',
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

  // PRIVATE METHODS

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
