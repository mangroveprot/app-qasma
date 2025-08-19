import 'package:dartz/dartz.dart';

import '../../data/models/appointment_model.dart';
import '../../data/models/params/approved_params.dart';
import '../../data/models/params/availability_params.dart';
import '../../data/models/params/cancel_params.dart';

abstract class AppointmentRepository {
  Future<Either> approved(ApprovedParams approvedReq);
  Future<Either> cancelAppointment(CancelParams cancelReq);
  Future<Either> counselorsAvailability(AvailabilityParams availabilityParams);
  Future<Either> createNewAppointment(AppointmentModel model);
  Future<Either> getAllAppointmentByUser();
  Future<Either> getAllAppointments();
  Future<Either> getSlots(String duration);
  Future<Either> syncAppointments();
  Future<Either> updateAppointment(AppointmentModel model);
}
