import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/params/dynamic_param.dart';
import '../repository/user_repositories.dart';

class SaveFcmTokenUsecase implements Usecase<Either, DynamicParam> {
  @override
  Future<Either> call({DynamicParam? param}) {
    return sl<UserRepository>().saveFcmToken(param!);
  }
}
