import 'package:dartz/dartz.dart';
import '../../../../common/error/app_error.dart';
import '../../data/models/appointment_config_model.dart';

abstract class AppointmentConfigService {
  Future<Either<AppError, List<AppointmentConfigModel>>> getConfig();
  Future<Either<AppError, List<AppointmentConfigModel>>> syncConfig();
}
