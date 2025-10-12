import 'package:dartz/dartz.dart';

import '../../data/models/params/dynamic_param.dart';

abstract class UserRepository {
  Future<Either> isRegister(String identifier);
  Future<Either> getAllUser();
  Future<Either> getUser(String idNumber);
  Future<Either> update(DynamicParam param);
  Future<Either> syncUser();
}
