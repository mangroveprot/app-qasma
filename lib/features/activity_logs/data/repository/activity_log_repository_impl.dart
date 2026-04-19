import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/activity_log_repository.dart';
import '../../domain/services/activity_log_service.dart';
import '../../domain/entities/activity_log.dart';

class ActivityLogRepositoryImpl extends ActivityLogRepository {
  final ActivityLogService _activityLogService = sl<ActivityLogService>();

  @override
  Future<Either<AppError, List<ActivityLog>>> getActivityLogsByUser() async {
    final result = await _activityLogService.getActivityLogsByUser();
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
