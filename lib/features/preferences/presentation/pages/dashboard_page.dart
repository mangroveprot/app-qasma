import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/button_ids.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
import '../../../activity_logs/presentation/bloc/activity_logs_cubit.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../controllers/dashboard_controller.dart';
import '../models/appointment_filter_model.dart';
import '../widgets/dashboard_widget/dashboard_filter_bottom_sheet.dart';
import '../widgets/dashboard_widget/dashboard_form.dart';
import '../widgets/skeletal/dashboard_skeleton_loader.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  late final DashboardController controller;
  bool _isLoading = true;
  AppointmentFilterModel _currentFilter = const AppointmentFilterModel();

  @override
  void initState() {
    super.initState();
    controller = DashboardController();
    _initializeWithDelay();
  }

  Future<void> _initializeWithDelay() async {
    controller.initialize();

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DashboardFilterBottomSheet(
          initialFilter: _currentFilter,
          onApply: (filter) {
            setState(() {
              _currentFilter = filter;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentsCubit, AppointmentCubitState>(
            listener: _handleAppointmentsState,
          ),
          BlocListener<UserCubit, UserCubitState>(
            listener: _handleUserState,
          ),
          BlocListener<ButtonCubit, ButtonState>(
            listener: _handleButtonState,
          ),
          BlocListener<ActivityLogsCubit, ActivityLogsCubitState>(
            listener: _handleActivityLogsState,
          ),
        ],
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Dashboard',
            backgroundColor: context.colors.background,
          ),
          body: _isLoading
              ? DashboardSkeletonLoader.dashboard()
              : LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: DashboardForm(
                      state: this,
                      filter: _currentFilter.hasActiveFilters ? _currentFilter : null,
                    ),
                  );
                }),
        ),
      ),
    );
  }

  void _handleAppointmentsState(
      BuildContext context, AppointmentCubitState state) {
    switch (state.runtimeType) {
      case AppointmentsFailureState:
        final failureState = state as AppointmentsFailureState;
        AppToast.show(
          message: failureState.primaryError,
          type: ToastType.error,
        );
        break;

      case AppointmentsLoadedState:
        final loadedState = state as AppointmentsLoadedState;
        if (loadedState.appointments.isEmpty) {
          AppToast.show(
            message: 'No appointment yet!',
            type: ToastType.original,
          );
        }
        break;
    }
  }

  void _handleUserState(BuildContext context, UserCubitState state) {
    if (state is UserFailureState) {
      AppToast.show(message: 'Failed to load user data', type: ToastType.error);
      debugPrint('Failed to load user: ${state.errorMessages}');
    }
  }

  void _handleActivityLogsState(
    BuildContext context,
    ActivityLogsCubitState state,
  ) {
    if (state is ActivityLogsFailureState) {
      AppToast.show(
        message: state.primaryError,
        type: ToastType.error,
      );
    }
  }

  Future<void> _handleButtonState(
      BuildContext context, ButtonState state) async {
    if (state is ButtonFailureState) {
      if (state.errorMessages.isNotEmpty) {
        AppToast.show(
          message: state.errorMessages.first,
          type: ToastType.error,
        );
      }

      if (state.suggestions.isNotEmpty) {
        Future.delayed(const Duration(seconds: 4), () {
          AppToast.show(
            message: state.suggestions.first,
            type: ToastType.original,
          );
        });
      }
    }

    if (state is ButtonSuccessState) {
      final buttonId = state.buttonId;
      if (buttonId == ButtonsUniqeKeys.downloadReports.id)
        return AppToast.show(
          message: 'File saved to Downloads folder as ${state.data}',
          type: ToastType.success,
          duration: const Duration(seconds: 5),
        );

      // await controller.appoitnmentRefreshData();
    }
  }
}
