import 'package:dartz/dartz.dart';

import '../../../users/data/models/user_model.dart';
import '../../data/models/signin_params.dart';

abstract class AuthService {
  Future<Either> signin(SigninParams signinReq);
  Future<Either> create_account(UserModel model);
}
