import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/params/qr_scan_params.dart';
import '../repository/appointment_repositories.dart';

class VerifyAppointmentUsecase implements Usecase<Either, QRScanParams> {
  @override
  Future<Either> call({QRScanParams? param}) {
    return sl<AppointmentRepository>().verifyAppointment(param!);
  }
}
