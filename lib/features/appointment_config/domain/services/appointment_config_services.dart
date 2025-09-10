import 'package:dartz/dartz.dart';
import '../../../../common/error/app_error.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../data/models/appointment_config_model.dart';

abstract class AppointmentConfigService {
  Future<Either<AppError, List<AppointmentConfigModel>>> getConfig();
  Future<Either<AppError, List<AppointmentConfigModel>>> syncConfig();
  Future<Either<AppError, bool>> update(DynamicParam configUpdateReq);
}
