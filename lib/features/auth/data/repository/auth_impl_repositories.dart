import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/user_model.dart';
import '../../domain/repository/auth_repositories.dart';
import '../../domain/services/auth_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService = sl<AuthService>();
  @override
  Future<Either> signUp(UserModel signupReq) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<Either> signin(UserModel signinReq) async {
    final Either result = await _authService.signin(signinReq);
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
