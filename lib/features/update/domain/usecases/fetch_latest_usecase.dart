import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/release_info_model.dart';
import '../repository/update_repository.dart';

class FetchLatestReleaseUsecase
    implements Usecase<Either<AppError, ReleaseInfoModel>, bool> {
  @override
  Future<Either<AppError, ReleaseInfoModel>> call({bool? param}) {
    return sl<UpdateRepository>()
        .fetchLatestRelease(bypassCache: param ?? false);
  }
}
