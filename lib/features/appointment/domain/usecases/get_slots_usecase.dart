import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/appointment_repositories.dart';

class GetSlotsUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? param}) {
    return sl<AppointmentRepository>().getSlots(param!);
  }
}
