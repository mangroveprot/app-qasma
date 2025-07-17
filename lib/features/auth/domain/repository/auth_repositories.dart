import 'package:dartz/dartz.dart';

import '../../data/models/signin_params.dart';
import '../../data/models/signup_params.dart';

abstract class AuthRepository {
  Future<Either> signUp(SignupParams signupReq);
  Future<Either> signin(SigninParams signinReq);
}
