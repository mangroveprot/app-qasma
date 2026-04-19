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
import '../models/activity_logs_page_result.dart';

class ActivityLogServiceImpl extends BaseService<ActivityLogModel>
    implements ActivityLogService {
  ActivityLogServiceImpl(AbstractRepository<ActivityLogModel> repository)
      : super(repository);

  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  final localRepo = sl<LocalRepository<ActivityLogModel>>();
  final _logger = Logger();

  @override
  Future<Either<AppError, ActivityLogsPageResult>> getActivityLogsByUser({
    required int page,
    required int limit,
    String? searchTerm,
    bool forceRefresh = false,
  }) async {
    try {
      if (forceRefresh) {
        await localRepo.clearAll();
      }

      final isSearch = searchTerm != null && searchTerm.trim().isNotEmpty;

      if (!isSearch && !forceRefresh) {
        final localCount = await localRepo.count();
        final requiredCount = page * limit;

        if (localCount >= requiredCount) {
          final items = await localRepo.getItemsPage(
            page: page,
            limit: limit,
            orderBy: 'createdAt',
            descending: true,
          );

          return Right(
            ActivityLogsPageResult(
              logs: items,
              page: page,
              limit: limit,
              total: localCount,
              hasMore: localCount > requiredCount,
              searchTerm: null,
            ),
          );
        }
      }

      final params = <String, dynamic>{
        'page': page,
        'limit': limit,
        'paginate': true,
      };

      if (isSearch) {
        params['searchTerm'] = searchTerm.trim();
      }

      final response = await _apiClient.get(
        _urlProviderConfig.activityLogEndPoint,
        requiresAuth: true,
        queryParameters: params,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => ActivityLogModel.fromJson(json),
      );

      if (!apiResponse.isSuccess || apiResponse.documents == null) {
        return Left(apiResponse.error ??
            AppError.create(
              message: 'Failed to load activity logs',
              type: ErrorType.server,
            ));
      }

      final docs = apiResponse.documents!;
      final total = apiResponse.total ?? docs.length;
      final currentPage = apiResponse.page ?? page;
      final currentLimit = apiResponse.limit ?? limit;
      final hasMore = total > currentPage * currentLimit;

      if (!isSearch) {
        try {
          await localRepo.saveAllItems(docs.toList());
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
      }

      return Right(
        ActivityLogsPageResult(
          logs: docs,
          page: currentPage,
          limit: currentLimit,
          total: total,
          hasMore: hasMore,
          searchTerm: isSearch ? searchTerm : null,
        ),
      );
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
