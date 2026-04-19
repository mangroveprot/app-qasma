import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/activity_logs_page_result.dart';
import '../repository/activity_log_repository.dart';

class GetActivityLogsByUserUsecase
    implements Usecase<Either<AppError, ActivityLogsPageResult>, Map<String, dynamic>?> {
  @override
  Future<Either<AppError, ActivityLogsPageResult>> call({Map<String, dynamic>? param}) {
    final repository = sl<ActivityLogRepository>();
    final page = (param?['page'] as int?) ?? 1;
    final limit = (param?['limit'] as int?) ?? 20;
    final searchTerm = param?['searchTerm'] as String?;
    final forceRefresh = (param?['forceRefresh'] as bool?) ?? false;

    return repository.getActivityLogsByUser(
      page: page,
      limit: limit,
      searchTerm: searchTerm,
      forceRefresh: forceRefresh,
    );
  }
}
