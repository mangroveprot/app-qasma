import '../../features/appointment/data/models/appointment_model.dart';
import '../../features/appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../features/appointment/domain/usecases/sync_appointments_usecase.dart';
import '../../features/appointment/presentation/bloc/appointments/appointments_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';
import '../utils/constant.dart';

class AppointmentManager {
  late final GetAllAppointmentUsecase _getAllAppointmentsUseCase;
  late final SyncAppointmentsUsecase _syncAppointmentsUsecase;

  AppointmentManager() {
    _getAllAppointmentsUseCase = sl<GetAllAppointmentUsecase>();
    _syncAppointmentsUsecase = sl<SyncAppointmentsUsecase>();
  }

  void loadAllAppointments(AppointmentsCubit cubit) {
    cubit.loadAppointments(usecase: _getAllAppointmentsUseCase);
  }

  Future<void> refreshAppointments(AppointmentsCubit cubit) async {
    await cubit.refreshAppointments(usecase: _syncAppointmentsUsecase);
  }

  void filterByStatus(String status, AppointmentsCubit cubit) {
    cubit.loadAppointmentsByStatus(
      status: status,
      usecase: _getAllAppointmentsUseCase,
    );
  }

  int compareAppointments(
    AppointmentModel a,
    AppointmentModel b, {
    isPriority = false,
    Property? status,
  }) {
    if (isPriority && status != null) {
      final String targetStatus = status.field.toLowerCase();
      final priorityA = a.status.toLowerCase() == targetStatus ? 1 : 2;
      final priorityB = b.status.toLowerCase() == targetStatus ? 1 : 2;

      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }
    }
    return b.createdAt.compareTo(a.createdAt);
  }
}
