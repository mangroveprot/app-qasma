import 'package:dartz/dartz.dart';

import '../../../../core/_usecase/usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/resend_otp_params.dart';
import '../repository/auth_repositories.dart';

class ResendOTPUsecase implements Usecase<Either, ResendOtpParams> {
  @override
  Future<Either> call({ResendOtpParams? param}) {
    return sl<AuthRepository>().resendOTPCode(param!);
  }
}
