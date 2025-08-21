import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/appointment_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';

class DashboardController {
  late final AppointmentsCubit _appointmentsCubit;
  late final UserCubit _userCubit;
  late final ButtonCubit _buttonCubit;

  late final AppointmentManager _appointmentManager;
  late final UserManager _userManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

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
      ];

  void initialize() {
    _initializeCubits();
    _initializeManagers();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _appointmentManager = AppointmentManager();
    _userManager = UserManager();
  }

  void _initializeCubits() {
    _appointmentsCubit = AppointmentsCubit();
    _userCubit = UserCubit();
    _buttonCubit = ButtonCubit();
  }

  void _loadInitialData() {
    refreshUsersData();
    appointmentRefreshData();
  }

  Future<void> refreshUsersData() async {
    await _userManager.refreshUser(_userCubit);
  }

  Future<void> appointmentRefreshData() async {
    await _appointmentManager.refreshAppointments(_appointmentsCubit);
  }
}
