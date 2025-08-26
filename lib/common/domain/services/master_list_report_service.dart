import 'package:dartz/dartz.dart';

import '../../data/config/master_list_report_config.dart';
import '../../data/model/master_list_model.dart';
import '../../error/app_error.dart';

abstract class MasterlistReportService {
  Future<Either<AppError, String>> generateReportFromTemplate({
    required List<MasterlistModel> entries,
    String templatePath = MasterlistConfig.defaultTemplatePath,
    String outputBaseName = MasterlistConfig.defaultOutputBaseName,
  });

  Future<Either<AppError, String>> generateReportFromMaps({
    required List<Map<String, dynamic>> rows,
    String templatePath = MasterlistConfig.defaultTemplatePath,
    String outputBaseName = MasterlistConfig.defaultOutputBaseName,
  });
}
