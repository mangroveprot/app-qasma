import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/params/cancel_params.dart';
import '../repository/appointment_repositories.dart';

class CancelAppointmentUsecase implements Usecase<Either, CancelParams> {
  @override
  Future<Either> call({CancelParams? param}) {
    return sl<AppointmentRepository>().cancelAppointment(param!);
  }
}
