import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../repository/appointment_config_repositories.dart';

class UpdateConfigUsecase implements Usecase<Either, DynamicParam> {
  @override
  Future<Either> call({DynamicParam? param}) {
    return sl<AppointmentConfigRepository>().update(param!);
  }
}
