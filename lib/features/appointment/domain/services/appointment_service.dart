import 'package:dartz/dartz.dart';

import '../../data/models/appointment_model.dart';
import '../../data/models/params/cancel_params.dart';

abstract class AppointmentService {
  Future<Either> createNewAppointment(AppointmentModel model);
  Future<Either> updateAppointment(AppointmentModel model);
  Future<Either> getAllAppointmentByUser();
  Future<Either> syncAppointments();
  Future<Either> getSlots(String duration);
  Future<Either> cancelAppointment(CancelParams cancelReq);
}
