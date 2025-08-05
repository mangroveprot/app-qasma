import 'package:dartz/dartz.dart';

abstract class AppointmentConfigRepository {
  Future<Either> getConfig();
  Future<Either> syncConfig();
}
