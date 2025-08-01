import 'package:flutter/material.dart';

import '../../features/appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../features/appointment/presentation/bloc/appointments_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';

class AppointmentManager {
  late final GetAllAppointmentUsecase _getAllAppointmentsUseCase;

  AppointmentManager() {
    _getAllAppointmentsUseCase = sl<GetAllAppointmentUsecase>();
  }

  void loadAllAppointments(AppointmentsCubit cubit) {
    cubit.loadAppointments(usecase: _getAllAppointmentsUseCase);
  }

  Future<void> refreshAppointments(AppointmentsCubit cubit) async {
    await cubit.refreshAppointments(usecase: _getAllAppointmentsUseCase);
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
