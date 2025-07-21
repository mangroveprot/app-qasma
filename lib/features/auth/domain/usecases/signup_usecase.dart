import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/user_model.dart';
import '../repository/auth_repositories.dart';

class SignupUsecase implements Usecase<Either, UserModel> {
  @override
  Future<Either> call({UserModel? param}) {
    return sl<AuthRepository>().signup(param!);
  }
}
