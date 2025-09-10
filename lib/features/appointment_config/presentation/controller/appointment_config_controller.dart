import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/appointment_config_manager.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../bloc/appointment_config_cubit.dart';

class AppointmentConfigController {
  late final AppointmentConfigCubit _appointmentConfigCubit;
  late final ButtonCubit _buttonCubit;

  late final AppointmentConfigManager _appointmentConfigManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<AppointmentConfigCubit>(
          create: (context) => _appointmentConfigCubit,
        ),
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
      ];

  void _loadInitialData() {
    _loadAppointmentConfig();
  }

  void initialize() {
    _initializeManagers();
    _initializeCubits();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _appointmentConfigManager = AppointmentConfigManager();
  }

  void _initializeCubits() {
    _appointmentConfigCubit = AppointmentConfigCubit();
    _buttonCubit = ButtonCubit();
  }

  ButtonCubit get buttonCubit => _buttonCubit;

  AppointmentConfigCubit get appointmentConfigCubit => _appointmentConfigCubit;

  void _loadAppointmentConfig() {
    _appointmentConfigManager
        .loadAllAppointmentsConfig(_appointmentConfigCubit);
  }
}
