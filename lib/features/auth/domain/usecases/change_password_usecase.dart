import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/change_password_params.dart';
import '../repository/auth_repositories.dart';

class ChangePasswordUsecase implements Usecase<Either, ChangePasswordParams> {
  @override
  Future<Either> call({ChangePasswordParams? param}) {
    return sl<AuthRepository>().changePassword(param!);
  }
}
