import 'package:dartz/dartz.dart';

import '../../../users/data/models/params/dynamic_param.dart';

abstract class AppointmentConfigRepository {
  Future<Either> getConfig();
  Future<Either> syncConfig();
  Future<Either> update(DynamicParam configUpdateReq);
}
