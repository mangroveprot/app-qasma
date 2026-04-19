import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/data/model/master_list_model.dart';
import '../../../../common/domain/usecases/GenerateMasterListReportUsecase.dart';
import '../../../../common/manager/appointment_manager.dart';
import '../../../../common/manager/appointment_config_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/utils/button_ids.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../activity_logs/domain/usecases/get_activity_logs_by_user_usecase.dart';
import '../../../activity_logs/presentation/bloc/activity_logs_cubit.dart';
import '../../../appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';

class DashboardController {
  late final AppointmentsCubit _appointmentsCubit;
  late final UserCubit _userCubit;
  late final ButtonCubit _buttonCubit;
  late final AppointmentConfigCubit _appointmentConfigCubit;
  late final ActivityLogsCubit _activityLogsCubit;

  late final AppointmentManager _appointmentManager;
  late final AppointmentConfigManager _appointmentConfigManager;
  late final UserManager _userManager;

  // bool _isInitialized = false;
  // bool get isInitialized => _isInitialized;

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
        BlocProvider<AppointmentConfigCubit>(
          create: (context) => _appointmentConfigCubit,
        ),
        BlocProvider<ActivityLogsCubit>(
          create: (context) => _activityLogsCubit,
        ),
      ];

  void initialize() {
    _initializeCubits();
    _initializeManagers();
    _loadInitialData();
    // _isInitialized = true;
  }

  void _initializeManagers() {
    _appointmentManager = AppointmentManager();
    _appointmentConfigManager = AppointmentConfigManager();
    _userManager = UserManager();
  }

  void _initializeCubits() {
    _appointmentsCubit = AppointmentsCubit();
    _userCubit = UserCubit();
    _buttonCubit = ButtonCubit();
    _appointmentConfigCubit = AppointmentConfigCubit();
    _activityLogsCubit = ActivityLogsCubit();
  }

  void _loadInitialData() {
    _loadUsersData();
    _loadAppointmentsData();
    _loadAppointmentConfigData();
    _loadActivityLogs();
  }

  void _loadUsersData() {
    _userManager.loadAllUser(_userCubit);
  }

  void _loadAppointmentsData() {
    _appointmentManager.loadAllAppointments(_appointmentsCubit);
  }

  void _loadAppointmentConfigData() {
    _appointmentConfigManager
        .loadAllAppointmentsConfig(_appointmentConfigCubit);
  }

  void _loadActivityLogs() {
    _refreshActivityLogs(forceRefresh: true);
  }

  Future<void> _refreshActivityLogs({bool forceRefresh = true}) async {
    await _activityLogsCubit.loadActivityLogs(
      params: {
        'page': 1,
        'limit': 20,
        'forceRefresh': forceRefresh,
      },
      usecase: sl<GetActivityLogsByUserUsecase>(),
    );
  }

  Future<void> refreshUsersData() async {
    await _userManager.refreshUser(_userCubit);
  }

  Future<void> appointmentRefreshData() async {
    await _appointmentManager.refreshAppointments(_appointmentsCubit);
  }

  void handleGenerateReport({
    required BuildContext context,
    required List<MasterlistModel> entries,
  }) {
    context.read<ButtonCubit>().execute(
          buttonId: ButtonsUniqeKeys.downloadReports.id,
          usecase: sl<GenerateMasterListReportUsecase>(),
          params: entries,
        );
  }
}
