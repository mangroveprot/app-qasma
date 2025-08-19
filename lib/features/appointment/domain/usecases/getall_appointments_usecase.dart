import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/appointment_model.dart';
import '../repository/appointment_repositories.dart';

class GetAllAppointmentsUsecase
    implements Usecase<Either, List<AppointmentModel>> {
  @override
  Future<Either> call({List<AppointmentModel>? param}) {
    return sl<AppointmentRepository>().getAllAppointments();
  }
}
