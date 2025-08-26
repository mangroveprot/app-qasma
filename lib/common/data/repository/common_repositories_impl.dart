import 'package:dartz/dartz.dart';

import '../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/common_repositories.dart';
import '../../domain/services/master_list_report_service.dart';
import '../../error/app_error.dart';
import '../model/master_list_model.dart';

class CommonRepositoryImpl implements CommonRepository {
  final MasterlistReportService _masterlistReportService =
      sl<MasterlistReportService>();

  @override
  Future<Either<AppError, String>> generateMasterListReport(
      List<MasterlistModel> masterlistReq) async {
    try {
      final result = await _masterlistReportService.generateReportFromTemplate(
          entries: masterlistReq);

      return result;
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during generating report',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }
}
