import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/logout_params.dart';
import '../repository/auth_repositories.dart';

class LogoutUsecase implements Usecase<Either, LogoutParams> {
  @override
  Future<Either> call({LogoutParams? param}) {
    return sl<AuthRepository>().logout(param!);
  }
}
