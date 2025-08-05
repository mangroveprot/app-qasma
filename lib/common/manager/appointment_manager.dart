import 'package:flutter/material.dart';

import '../../features/appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../features/appointment/domain/usecases/sync_appointments_usecase.dart';
import '../../features/appointment/presentation/bloc/appointments_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';

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

  Future<void> cancelAppointment(String appointmentId, String reason) async {
    // TODO: Implement actual cancellation logic using proper domain service
    // Example: await appointmentService.cancelAppointment(appointmentId, reason);
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Cancelled appointment $appointmentId with reason: $reason');
  }
}
