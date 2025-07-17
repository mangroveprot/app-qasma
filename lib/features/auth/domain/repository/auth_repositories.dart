import 'package:dartz/dartz.dart';

import '../../../users/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either> signUp(UserModel signupReq);
  Future<Either> signin(UserModel signinReq);
}
