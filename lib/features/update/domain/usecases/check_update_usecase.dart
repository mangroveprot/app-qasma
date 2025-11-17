import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/update_repository.dart';

class CheckUpdateUsecase
    implements Usecase<Either<AppError, Map<String, dynamic>>, void> {
  @override
  Future<Either<AppError, Map<String, dynamic>>> call({void param}) {
    return sl<UpdateRepository>().getUpdateInfo();
  }
}
