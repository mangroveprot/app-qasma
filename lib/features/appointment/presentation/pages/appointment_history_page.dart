import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../bloc/appointments/appointments_cubit.dart';
import '../controllers/appointment_history_controller.dart';
import '../widgets/history_widget/history_form.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({super.key});

  @override
  State<AppointmentHistory> createState() => AppointmentHistoryState();
}

class AppointmentHistoryState extends State<AppointmentHistory> {
  late final AppointmentHistoryController controller;

  @override
  void initState() {
    super.initState();
    controller = AppointmentHistoryController();
    controller.initialize();
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
        ],
        child: Scaffold(
          appBar: const CustomAppBar(title: 'History'),
          body: !controller.isInitialized
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: HistoryForm(
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
}
