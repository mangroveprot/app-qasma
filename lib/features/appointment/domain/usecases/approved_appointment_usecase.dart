import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/params/approved_params.dart';
import '../repository/appointment_repositories.dart';

class ApprovedAppointmentUsecase implements Usecase<Either, ApprovedParams> {
  @override
  Future<Either> call({ApprovedParams? param}) {
    return sl<AppointmentRepository>().approved(param!);
  }
}
