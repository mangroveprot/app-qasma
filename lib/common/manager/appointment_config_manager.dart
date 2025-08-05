import '../../features/appointment_config/domain/usecases/sync_config_usecase.dart';
import '../../features/appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';

class AppointmentConfigManager {
  late final SyncConfigUsacase _syncConfigUsacase;

  AppointmentConfigManager() {
    _syncConfigUsacase = sl<SyncConfigUsacase>();
  }

  void loadAllAppointmentsConfig(AppointmentConfigCubit cubit) {
    cubit.loadAppointmentConfig(usecase: _syncConfigUsacase);
  }
}
