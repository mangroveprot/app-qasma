import 'package:dartz/dartz.dart';

import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/appointment_repositories.dart';
import '../../domain/services/appointment_service.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final AppointmentService _appointmentService = sl<AppointmentService>();

  @override
  Future<Either> getAll() async {
    final Either result = await _appointmentService.getAllAppointment();
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
