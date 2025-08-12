import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/appointment_manager.dart';
import '../bloc/appointments/appointments_cubit.dart';

class AppointmentHistoryController {
  late final AppointmentsCubit _appointmentsCubit;

  late final AppointmentManager _appointmentManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<AppointmentsCubit>(
          create: (context) => _appointmentsCubit,
        ),
      ];

  void initialize() {
    _initializeManagers();
    _initializeCubits();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _appointmentManager = AppointmentManager();
  }

  void _initializeCubits() {
    _appointmentsCubit = AppointmentsCubit();
  }

  void _loadInitialData() {
    appointmentRefreshData();
  }

  Future<void> appointmentRefreshData() async {
    await _appointmentManager.refreshAppointments(_appointmentsCubit);
  }
}
