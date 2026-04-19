import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../entities/activity_log.dart';

abstract class ActivityLogRepository {
  Future<Either<AppError, List<ActivityLog>>> getActivityLogsByUser();
  Future<Either<AppError, List<ActivityLog>>> syncActivityLogs();
}
