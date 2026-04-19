import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../data/models/activity_logs_page_result.dart';
import '../entities/activity_log.dart';

abstract class ActivityLogService {
  Future<Either<AppError, ActivityLogsPageResult>> getActivityLogsByUser({
    required int page,
    required int limit,
    String? searchTerm,
    bool forceRefresh = false,
  });

  Future<Either<AppError, List<ActivityLog>>> syncActivityLogs();
}
