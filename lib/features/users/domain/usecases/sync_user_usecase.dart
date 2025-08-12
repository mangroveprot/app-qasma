import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/user_model.dart';
import '../repository/user_repositories.dart';

class SyncUserUsecase implements Usecase<Either, List<UserModel>> {
  @override
  Future<Either> call({List<UserModel>? param}) {
    return sl<UserRepository>().syncUser();
  }
}
