import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/activity_logs_page_result.dart';
import '../../domain/entities/activity_log.dart';
import '../../domain/repository/activity_log_repository.dart';
import '../../domain/services/activity_log_service.dart';

class ActivityLogRepositoryImpl extends ActivityLogRepository {
  final ActivityLogService _activityLogService = sl<ActivityLogService>();

  @override
  Future<Either<AppError, ActivityLogsPageResult>> getActivityLogsByUser({
    required int page,
    required int limit,
    String? searchTerm,
    bool forceRefresh = false,
  }) async {
    final result = await _activityLogService.getActivityLogsByUser(
      page: page,
      limit: limit,
      searchTerm: searchTerm,
      forceRefresh: forceRefresh,
    );
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<AppError, List<ActivityLog>>> syncActivityLogs() async {
    final result = await _activityLogService.syncActivityLogs();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }
}
