import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../domain/repository/appointment_config_repositories.dart';
import '../../domain/services/appointment_config_services.dart';
import '../models/appointment_config_model.dart';

class AppointmentConfigRepositoryImpl implements AppointmentConfigRepository {
  final AppointmentConfigService _configService =
      sl<AppointmentConfigService>();

  @override
  Future<Either<AppError, AppointmentConfigModel?>> getConfig() async {
    final Either result = await _configService.getConfig();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data.isNotEmpty ? data.first : null),
    );
  }

  @override
  Future<Either<AppError, AppointmentConfigModel?>> syncConfig() async {
    final result = await _configService.syncConfig();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data.isNotEmpty ? data.first : null),
    );
  }

  @override
  Future<Either<AppError, bool>> update(DynamicParam configUpdateReq) async {
    final result = await _configService.update(configUpdateReq);
    return result.fold(
      (error) => Left(error),
      (user) => Right(user),
    );
  }
}
