import 'package:dartz/dartz.dart';
import '../../data/models/appointment_model.dart';
import '../repository/appointment_repositories.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';

class CreateNewAppointmentUsecase implements Usecase<Either, AppointmentModel> {
  @override
  Future<Either> call({AppointmentModel? param}) {
    return sl<AppointmentRepository>().createNewAppointment(param!);
  }
}
