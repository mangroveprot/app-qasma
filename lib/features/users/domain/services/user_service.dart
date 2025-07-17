import 'package:dartz/dartz.dart';

abstract class UserService {
  Future<Either> isRegister(String identifier);
}
