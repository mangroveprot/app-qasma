import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/user_model.dart';
import '../repository/user_repositories.dart';

class GetAllUserUsecase implements Usecase<Either, UserModel> {
  @override
  Future<Either> call({UserModel? param}) {
    return sl<UserRepository>().getAllUser();
  }
}
