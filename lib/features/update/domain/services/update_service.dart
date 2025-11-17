import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../data/models/github_release_model.dart';
import '../../data/models/release_info_model.dart';

abstract class UpdateService {
  Future<Either<AppError, GitHubReleaseModel>> getLatestRelease({
    bool bypassCache = false,
  });

  Future<Either<AppError, ReleaseInfoModel>> fetchLatestRelease({
    bool bypassCache = false,
  });

  Future<Either<AppError, bool>> isUpdateAvailable();

  Future<Either<AppError, Map<String, dynamic>>> getUpdateInfo();
}
