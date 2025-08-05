import 'package:dartz/dartz.dart';

abstract class AppointmentRepository {
  Future<Either> getAllAppointmentByUser();
  Future<Either> syncAppointments();
  Future<Either> getSlots(String duration);
}
