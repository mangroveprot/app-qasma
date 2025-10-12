import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../domain/repository/appointment_repositories.dart';
import '../../domain/services/appointment_service.dart';
import '../models/appointment_model.dart';
import '../models/params/cancel_params.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final AppointmentService _appointmentService = sl<AppointmentService>();

  @override
  Future<Either> getAllAppointmentByUser() async {
    final Either result = await _appointmentService.getAllAppointmentByUser();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> syncAppointments() async {
    final Either result = await _appointmentService.syncAppointments();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> getSlots(
      String duration) async {
    final Either result = await _appointmentService.getSlots(duration);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, AppointmentModel>> createNewAppointment(
      AppointmentModel model) async {
    final Either result = await _appointmentService.createNewAppointment(model);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, AppointmentModel>> updateAppointment(
      DynamicParam model) async {
    final Either result = await _appointmentService.updateAppointment(model);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, bool>> cancelAppointment(
      CancelParams cancelReq) async {
    final Either result =
        await _appointmentService.cancelAppointment(cancelReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
