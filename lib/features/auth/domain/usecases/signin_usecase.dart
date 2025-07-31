import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/signin_params.dart';
import '../repository/auth_repositories.dart';

class SigninUsecase implements Usecase<Either, SigninParams> {
  @override
  Future<Either> call({SigninParams? param}) {
    return sl<AuthRepository>().signin(param!);
  }
}
