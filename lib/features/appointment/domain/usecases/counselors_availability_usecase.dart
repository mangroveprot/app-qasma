import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/params/availability_params.dart';
import '../repository/appointment_repositories.dart';

class CounselorsAvailabilityUsecase
    implements Usecase<Either, AvailabilityParams> {
  @override
  Future<Either> call({AvailabilityParams? param}) {
    return sl<AppointmentRepository>().counselorsAvailability(param!);
  }
}
