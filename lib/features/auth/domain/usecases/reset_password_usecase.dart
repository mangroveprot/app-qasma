import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/reset_password_params.dart';
import '../repository/auth_repositories.dart';

class ResetPasswordUsecase implements Usecase<Either, ResetPasswordParams> {
  @override
  Future<Either> call({ResetPasswordParams? param}) {
    return sl<AuthRepository>().resetPassword(param!);
  }
}
