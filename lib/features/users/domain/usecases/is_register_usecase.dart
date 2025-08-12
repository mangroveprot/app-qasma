import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../repository/user_repositories.dart';

class IsRegisterUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? param}) {
    return sl<UserRepository>().isRegister(param!);
  }
}
