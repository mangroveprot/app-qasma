import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/entities/activity_log.dart';
import '../../domain/services/activity_log_service.dart';
import '../models/activity_log_model.dart';

class ActivityLogServiceImpl extends BaseService<ActivityLogModel>
    implements ActivityLogService {
  ActivityLogServiceImpl(AbstractRepository<ActivityLogModel> repository)
      : super(repository);

  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  final localRepo = sl<LocalRepository<ActivityLogModel>>();
  final _logger = Logger();

  @override
  Future<Either<AppError, List<ActivityLog>>> getActivityLogsByUser() async {
    try {
      final response = await _apiClient.get(
        _urlProviderConfig.activityLogEndPoint + '/getAllByUser/',
        requiresAuth: true,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => ActivityLogModel.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.documents != null) {
        try {
          await localRepo.saveAllItems(apiResponse.documents!.toList());
        } catch (e, stackTrace) {
          _logger.e('Failed to save activity log data locally', e, stackTrace);
          return Left(AppError.create(
            message:
                'Something went wrong while saving your data. Please contact the administrator.',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          ));
        }
        return Right(apiResponse.documents!);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during fetching activity logs',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, List<ActivityLog>>> syncActivityLogs() async {
    try {
      await sync();
      final response = await getAll();
      return Right(response);
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during syncing activity logs',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }
}
