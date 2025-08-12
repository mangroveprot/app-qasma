import '../../features/appointment_config/domain/usecases/sync_config_usecase.dart';
import '../../features/appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';

class AppointmentConfigManager {
  late final SyncConfigUsecase _syncConfigUsacase;

  AppointmentConfigManager() {
    _syncConfigUsacase = sl<SyncConfigUsecase>();
  }

  void loadAllAppointmentsConfig(AppointmentConfigCubit cubit) {
    cubit.loadAppointmentConfig(usecase: _syncConfigUsacase);
  }

  Future<void> refreshAppointmentsConfig(AppointmentConfigCubit cubit) async {
    await cubit.loadAppointmentConfig(usecase: _syncConfigUsacase);
  }
}
