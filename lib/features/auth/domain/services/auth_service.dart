import 'package:dartz/dartz.dart';

import '../../../users/data/models/user_model.dart';

abstract class AuthService {
  Future<Either> signin(UserModel signinReq);
  Future<Either> create_account(UserModel model);
}
