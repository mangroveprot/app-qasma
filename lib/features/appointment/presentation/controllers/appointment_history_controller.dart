import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/appointment_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../../../users/presentation/bloc/user_cubit_extensions.dart';
import '../bloc/appointments/appointments_cubit.dart';

class AppointmentHistoryController {
  late final UserCubit _userCubit;
  late final AppointmentsCubit _appointmentsCubit;

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
      ];

  void initialize() {
    _initializeManagers();
    _initializeCubits();
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
  }

  void _loadInitialData() {
    appointmentRefreshData();
    getAllUser();
  }

  Future<void> appointmentRefreshData() async {
    await _appointmentManager.refreshAppointments(_appointmentsCubit);
  }

  Future<void> getAllUser() async {
    await _userManager.refreshUser(_userCubit);
  }

  UserModel? getUserByIdNumber(String idNumber) {
    return _userCubit.getUserByIdNumber(idNumber);
  }

  List<UserModel>? getUsers() {
    return _userCubit.getAllUser();
  }

  AppointmentManager get appointmentManager => _appointmentManager;
  UserCubit get userCubit => _userCubit;
}
