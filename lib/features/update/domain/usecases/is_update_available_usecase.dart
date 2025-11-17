import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/update_repository.dart';

class IsUpdateAvailableUsecase
    implements Usecase<Either<AppError, bool>, void> {
  @override
  Future<Either<AppError, bool>> call({void param}) {
    return sl<UpdateRepository>().isUpdateAvailable();
  }
}
