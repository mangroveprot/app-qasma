import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../data/models/release_info_model.dart';

abstract class UpdateRepository {
  Future<Either<AppError, ReleaseInfoModel>> fetchLatestRelease({
    bool bypassCache = false,
  });

  Future<Either<AppError, bool>> isUpdateAvailable();

  Future<Either<AppError, Map<String, dynamic>>> getUpdateInfo();
}
