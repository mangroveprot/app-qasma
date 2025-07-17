import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/auth_repositories.dart';
import '../../domain/services/user_service.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService = sl<UserService>();
  @override
  Future<Either> getUser(String identifier) async {
    final Either result = await _userService.getUser(identifier);
    return result.fold(
      (error) {
        return Left(error.message);
      },
      (data) {
        final Response response = data;
        return Right(response);
      },
    );
  }
}
