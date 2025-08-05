import 'package:dartz/dartz.dart';

abstract class AppointmentService {
  Future<Either> getAllAppointmentByUser();
  Future<Either> syncAppointments();
  Future<Either> getSlots(String duration);
}
