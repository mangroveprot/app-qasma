import 'package:dartz/dartz.dart';

abstract class UserService {
  Future<Either> isRegister(String identifier);
  Future<Either> getUser(String idNumber);
}
