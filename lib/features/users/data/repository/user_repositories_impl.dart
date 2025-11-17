import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/user_repositories.dart';
import '../../domain/services/user_service.dart';
import '../models/params/dynamic_param.dart';
import '../models/user_model.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService = sl<UserService>();

  @override
  Future<Either<AppError, List<UserModel>>> getAllUser() async {
    final Either result = await _userService.getAllUser();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

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

  @override
  Future<Either<AppError, bool>> update(DynamicParam param) async {
    final result = await _userService.update(param);
    return result.fold(
      (error) => Left(error),
      (user) => Right(user),
    );
  }

  @override
  Future<Either> syncUser() async {
    final result = await _userService.syncUser();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either> saveFcmToken(DynamicParam param) async {
    final result = await _userService.saveFcmToken(param);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
