import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/update_repository.dart';
import '../../domain/services/update_service.dart';
import '../models/release_info_model.dart';

class UpdateRepositoryImpl extends UpdateRepository {
  final UpdateService _updateService = sl<UpdateService>();

  @override
  Future<Either<AppError, ReleaseInfoModel>> fetchLatestRelease({
    bool bypassCache = false,
  }) async {
    final result = await _updateService.fetchLatestRelease(
      bypassCache: bypassCache,
    );
    return result.fold(
      (error) => Left(error),
      (releaseInfo) => Right(releaseInfo),
    );
  }

  @override
  Future<Either<AppError, bool>> isUpdateAvailable() async {
    final result = await _updateService.isUpdateAvailable();
    return result.fold(
      (error) => Left(error),
      (hasUpdate) => Right(hasUpdate),
    );
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> getUpdateInfo() async {
    final result = await _updateService.getUpdateInfo();
    return result.fold(
      (error) => Left(error),
      (updateInfo) => Right(updateInfo),
    );
  }
}
