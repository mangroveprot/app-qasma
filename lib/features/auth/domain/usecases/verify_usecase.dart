import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/verify_params.dart';
import '../repository/auth_repositories.dart';

class VerifyUsecase implements Usecase<Either, VerifyParams> {
  @override
  Future<Either> call({VerifyParams? param}) {
    return sl<AuthRepository>().verify(param!);
  }
}
