import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> getUser(String identifier);
}
