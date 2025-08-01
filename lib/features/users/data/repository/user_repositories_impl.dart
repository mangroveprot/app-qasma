import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/auth_repositories.dart';
import '../../domain/services/user_service.dart';
import '../models/user_model.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService = sl<UserService>();

  @override
  Future<Either<AppError, bool>> isRegister(String identifier) async {
    final result = await _userService.isRegister(identifier);
    return result.fold(
      (error) => Left(error),
      (isRegistered) => Right(isRegistered),
    );
  }

  @override
  Future<Either<AppError, UserModel>> getUser(String idNumber) async {
    final result = await _userService.getUser(idNumber);
    return result.fold(
      (error) => Left(error),
      (user) => Right(user),
    );
  }
}
