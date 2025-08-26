import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../domain/services/appointment_config_services.dart';
import '../models/appointment_config_model.dart';

class AppointmentConfigServiceImpl extends BaseService<AppointmentConfigModel>
    implements AppointmentConfigService {
  AppointmentConfigServiceImpl(
      AbstractRepository<AppointmentConfigModel> repository)
      : super(repository);

  // final ApiClient _apiClient = sl<ApiClient>();
  // final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  // final _localRepo = sl<LocalRepository<AppointmentConfigModel>>();
  // final _logger = Logger();

  @override
  Future<Either<AppError, List<AppointmentConfigModel>>> getConfig() async {
    try {
      final configs = await repository.getAllItems();
      return Right(configs);
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getting config',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, List<AppointmentConfigModel>>> syncConfig() async {
    try {
      await sync();
      final response = await getAll();
      return Right(response);
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getting config',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }
}
