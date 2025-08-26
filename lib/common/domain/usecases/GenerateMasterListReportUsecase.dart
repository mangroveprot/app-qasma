import 'package:dartz/dartz.dart';

import '../../../core/_usecase/usecase.dart';
import '../../../infrastructure/injection/service_locator.dart';
import '../../data/model/master_list_model.dart';
import '../repository/common_repositories.dart';

class GenerateMasterListReportUsecase
    implements Usecase<Either, List<MasterlistModel>> {
  @override
  Future<Either> call({List<MasterlistModel>? param}) {
    return sl<CommonRepository>().generateMasterListReport(param!);
  }
}
