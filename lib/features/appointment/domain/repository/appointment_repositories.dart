import 'package:dartz/dartz.dart';

import '../../../users/data/models/params/dynamic_param.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/params/cancel_params.dart';

abstract class AppointmentRepository {
  Future<Either> createNewAppointment(AppointmentModel model);
  Future<Either> updateAppointment(DynamicParam model);
  Future<Either> getAllAppointmentByUser();
  Future<Either> syncAppointments();
  Future<Either> getSlots(String duration);
  Future<Either> cancelAppointment(CancelParams cancelReq);
}
