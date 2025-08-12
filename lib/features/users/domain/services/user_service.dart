import 'package:dartz/dartz.dart';

import '../../data/models/params/dynamic_param.dart';

abstract class UserService {
  Future<Either> isRegister(String identifier);
  Future<Either> getUser(String idNumber);
  Future<Either> update(DynamicParam param);
  Future<Either> syncUser();
}
