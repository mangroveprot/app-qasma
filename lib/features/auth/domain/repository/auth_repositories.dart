import 'package:dartz/dartz.dart';

import '../../../users/data/models/user_model.dart';
import '../../data/models/signin_params.dart';

abstract class AuthRepository {
  Future<Either> signup(UserModel signupReq);
  Future<Either> signin(SigninParams signinReq);
}
