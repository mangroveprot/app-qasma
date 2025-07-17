import 'package:dartz/dartz.dart';

import '../../data/models/signin_params.dart';

abstract class AuthService {
  Future<Either> signin(SigninParams signinReq);
}
