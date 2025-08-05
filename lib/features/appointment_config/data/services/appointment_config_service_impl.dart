import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
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
  final _logger = Logger();

  @override
  Future<Either<AppError, List<AppointmentConfigModel>>> getConfig() async {
    try {
      final response = await _apiClient.get(
        _urlProviderConfig.getConfig,
        requiresAuth: true,
      );

      if (response.data['success'] == true &&
          response.data['documents'] != null &&
          response.data['documents'].isNotEmpty) {
        final documents = response.data['documents'] as List;

        final List<AppointmentConfigModel> configModels = documents
            .map((doc) =>
                AppointmentConfigModel.fromJson(doc as Map<String, dynamic>))
            .toList();

        try {
          await _localRepo.saveAllItems(configModels);
        } catch (e, stackTrace) {
          _logger.e('Failed to save config data locally', e, stackTrace);

          return Left(AppError.create(
            message:
                'Something went wrong while saving your data. Please contact the administrator.',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          ));
        }

        // ✅ Return the actual config models instead of just bool
        return Right(configModels);
      } else {
        return Left(AppError.create(
          message: 'No configuration found',
          type: ErrorType.notFound,
        ));
      }
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
