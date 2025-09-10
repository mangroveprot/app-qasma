import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../domain/services/appointment_config_services.dart';
import '../models/appointment_config_model.dart';

class AppointmentConfigServiceImpl extends BaseService<AppointmentConfigModel>
    implements AppointmentConfigService {
  AppointmentConfigServiceImpl(
      AbstractRepository<AppointmentConfigModel> repository)
      : super(repository);

  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  final _localRepo = sl<LocalRepository<AppointmentConfigModel>>();
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

  @override
  Future<Either<AppError, bool>> update(DynamicParam configUpdateReq) async {
    try {
      final configId = configUpdateReq.fields['configId'];

      if (configId == null) {
        return Left(AppError.create(
          message: 'Config ID is required in the parameters',
          type: ErrorType.validation,
        ));
      }

      final data = Map<String, dynamic>.from(configUpdateReq.fields);
      data.remove('configId');

      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.updateConfig,
        [configId.toString()],
      );

      final response = await _apiClient.patch(
        url,
        data: data,
        requiresAuth: true,
      );

      final apiResponse = ApiResponse.fromJson(response.data, (json) => json);

      if (apiResponse.isSuccess) {
        _reloadData();
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during update',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  void _reloadData() {
    Future.microtask(() async {
      await Future.wait([sync()]);
    });
  }
}
