import 'package:dartz/dartz.dart';

abstract class UserService {
  Future<Either> getUser(String identifier);
}
