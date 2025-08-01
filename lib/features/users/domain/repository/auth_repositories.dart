import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> isRegister(String identifier);
  Future<Either> getUser(String idNumber);
}
