import 'package:dartz/dartz.dart';

import '../../data/model/master_list_model.dart';
import '../../error/app_error.dart';

abstract class CommonRepository {
  Future<Either<AppError, String>> generateMasterListReport(
    List<MasterlistModel> masterlistReq,
  );
}
