import 'package:dartz/dartz.dart';

abstract class AppointmentService {
  Future<Either> getAllAppointment();
}
