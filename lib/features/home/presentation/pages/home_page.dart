import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../../../common/utils/constant.dart';
import '../../../../common/utils/menu_items_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../common/widgets/modal.dart';
import '../../../../common/widgets/toast/custom_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../../appointment/presentation/bloc/appointments_cubit.dart';
import '../widgets/home_widget/home_fab.dart';
import '../widgets/home_widget/home_form.dart';
import '../widgets/main_appbar.dart';
import '../widgets/sidbar_widget/custom_sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  // Cubits
  late AppointmentsCubit _appointmentsCubit;
  late ButtonCubit _buttonCubit;

  // Use cases
  late GetAllAppointmentUsecase _getAllAppointmentsUseCase;

  // Stream subscriptions for manual disposal if needed
  StreamSubscription<AppointmentCubitState>? _appointmentsSubscription;

  // Loading state for initial data
  bool _isInitialLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
    _loadInitialData();
  }

  void _initializeDependencies() {
    _getAllAppointmentsUseCase = sl<GetAllAppointmentUsecase>();
    _appointmentsCubit = AppointmentsCubit();
    _buttonCubit = ButtonCubit();
  }

  void _loadInitialData() {
    _appointmentsCubit.loadAppointments(
      usecase: _getAllAppointmentsUseCase,
    );
  }

  // Refresh method for pull-to-refresh
  Future<void> refreshData() async {
    await _appointmentsCubit.refreshAppointments(
      usecase: _getAllAppointmentsUseCase,
    );
  }

  // Filter appointments by status
  void filterAppointmentsByStatus(String status) {
    _appointmentsCubit.loadAppointmentsByStatus(
      status: status,
      usecase: _getAllAppointmentsUseCase,
    );
  }

  // Search appointments
  void searchAppointments(String query) {
    if (query.isEmpty) {
      _appointmentsCubit.clearFilters();
    } else {
      _appointmentsCubit.searchAppointments(query);
    }
  }

  Future<void> handleCancelAppointment(String appointmentId) async {
    final result = await CustomModal.showCenteredModal<bool>(
      context,
      title: 'Are you sure to cancel this appointment $appointmentId?',
      subtitle: 'Date: December 24, 2025 - 10:30am',
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
    );

    if (result == true) {
      final selectedReason = await CustomModal.showRadioSelectionModal<String>(
        context,
        options: reasonOptionList,
        title: 'Select Cancellation Reason',
        onConfirm: (String reason) async {
          await Future.delayed(const Duration(milliseconds: 500));
          return reason;
        },
      );

      if (selectedReason != null) {
        // Here you would call your cancel appointment use case
        // _buttonCubit.execute(
        //   params: {'appointmentId': appointmentId, 'reason': selectedReason},
        //   usecase: cancelAppointmentUseCase,
        // );
        debugPrint('Selected cancellation reason: $selectedReason');

        // Refresh appointments after cancellation
        refreshData();
      }
    }
  }

  void handleRescheduleAppointment(String appointmentId) {
    // Handle appointment rescheduling
    debugPrint('Reschedule appointment: $appointmentId');
  }

  void handleShowHistory() {
    // Handle show history
    debugPrint('Show appointment history');
  }

  void _handleMenuItemTap(String menuItem) {
    switch (menuItem) {
      case MenuKeys.appointments:
        debugPrint('Navigating to Appointments');
        break;
      case MenuKeys.myProfile:
        debugPrint('Navigating to Profile');
        break;
      case MenuKeys.history:
        debugPrint('Navigating to History');
        break;
      case MenuKeys.privacyPolicy:
        debugPrint('Navigating to Privacy Policy');
        break;
      case MenuKeys.termsAndCondition:
        debugPrint('Navigating to Terms');
        break;
      case MenuKeys.settings:
        debugPrint('Navigating to Settings');
        break;
      case MenuKeys.logout:
        _handleLogout();
        break;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                debugPrint('User logged out');
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _handleNotificationTap() {
    debugPrint('Notification bell tapped');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _buttonCubit),
        BlocProvider.value(value: _appointmentsCubit),
      ],
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawerScrimColor: Colors.black54,
        drawerEdgeDragWidth: 60,
        appBar: MainAppBar(
          title: 'JRMSU-KC QASMA',
          onNotificationTap: _handleNotificationTap,
        ),
        drawer: CustomSidebar(
          userName: 'Jane Doe',
          onMenuItemTap: _handleMenuItemTap,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ButtonCubit, ButtonState>(
              listener: _handleButtonState,
            ),
            BlocListener<AppointmentsCubit, AppointmentCubitState>(
              listener: _handleAppointmentsState,
            ),
          ],
          child: SafeArea(
            child: HomeForm(
              state: this,
              //onRefresh: refreshData,
            ),
          ),
        ),
        floatingActionButton: const RepaintBoundary(child: HomeFab()),
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonFailureState) {
      if (state.errorMessages.isNotEmpty) {
        CustomToast.error(context: context, message: state.errorMessages.first);
      }
    }

    if (state is ButtonSuccessState) {
      // Handle success - maybe refresh appointments
      CustomToast.success(
          context: context, message: 'Action completed successfully');
      refreshData();
    }
  }

  void _handleAppointmentsState(
      BuildContext context, AppointmentCubitState state) {
    if (state is AppointmentsFailureState) {
      CustomToast.error(
        context: context,
        message: state.primaryError,
      );
    }

    if (state is AppointmentsLoadedState) {
      if (_isInitialLoading) {
        _isInitialLoading = false;
        // Optional: Show success message for initial load
        if (state.appointments.isEmpty) {
          CustomToast.info(context: context, message: 'No appointments found');
        }
      }
    }
  }

  @override
  void dispose() {
    // Cancel any active subscriptions
    _appointmentsSubscription?.cancel();

    // Close cubits
    _appointmentsCubit.close();
    _buttonCubit.close();

    super.dispose();
  }
}
