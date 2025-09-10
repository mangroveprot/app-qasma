import '../../features/appointment_config/domain/usecases/get_config_usecase.dart';
import '../../features/appointment_config/domain/usecases/sync_config_usecase.dart';
import '../../features/appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';

class AppointmentConfigManager {
  late final SyncConfigUsecase _syncConfigUsacase;
  late final GetConfigUseCase _getConfigUseCase;

  AppointmentConfigManager() {
    _syncConfigUsacase = sl<SyncConfigUsecase>();
    _getConfigUseCase = sl<GetConfigUseCase>();
  }

  void loadAllAppointmentsConfig(AppointmentConfigCubit cubit) {
    cubit.loadAppointmentConfig(usecase: _getConfigUseCase);
  }

  Future<void> refreshAppointmentsConfig(AppointmentConfigCubit cubit) async {
    await cubit.loadAppointmentConfig(usecase: _syncConfigUsacase);
  }
}
