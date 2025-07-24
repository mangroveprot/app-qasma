import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/user_model.dart';
import '../../domain/repository/auth_repositories.dart';
import '../../domain/services/auth_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService = sl<AuthService>();
  @override
  Future<Either> signup(UserModel model) async {
    final Either result = await _authService.create_account(model);
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
  Future<Either> signin(UserModel signinReq) async {
    final Either result = await _authService.signin(signinReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        final Response response = data;
        return Right(response);
      },
    );
  }
}
