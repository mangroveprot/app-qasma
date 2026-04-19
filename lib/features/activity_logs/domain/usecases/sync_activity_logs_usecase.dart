import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/activity_log_repository.dart';

class SyncActivityLogsUsecase implements Usecase<Either, void> {
  @override
  Future<Either> call({param}) {
    return sl<ActivityLogRepository>().syncActivityLogs();
  }
}
