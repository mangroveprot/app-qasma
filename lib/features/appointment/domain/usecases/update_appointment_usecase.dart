import 'package:dartz/dartz.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../repository/appointment_repositories.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';

class UpdateAppointmentUsecase implements Usecase<Either, DynamicParam> {
  @override
  Future<Either> call({DynamicParam? param}) {
    return sl<AppointmentRepository>().updateAppointment(param!);
  }
}
