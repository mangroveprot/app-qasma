import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> isRegister(String identifier);
}
