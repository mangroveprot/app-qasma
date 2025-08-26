import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/button_ids.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../controllers/dashboard_controller.dart';
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
            message: 'You dont have appointment yet!',
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
