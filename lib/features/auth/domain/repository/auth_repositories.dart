import 'package:dartz/dartz.dart';

import '../../../users/data/models/user_model.dart';
import '../../data/models/logout_params.dart';
import '../../data/models/resend_otp_params.dart';
import '../../data/models/reset_password_params.dart';
import '../../data/models/signin_params.dart';
import '../../data/models/verify_params.dart';

abstract class AuthRepository {
  Future<Either> signup(UserModel signupReq);
  Future<Either> signin(SigninParams signinReq);
  Future<Either> resendOTPCode(ResendOtpParams resendReq);
  Future<Either> verify(VerifyParams verifyReq);
  Future<Either> forgotPassword(String param);
  Future<Either> resetPassword(ResetPasswordParams resetReq);
  Future<Either> logout(LogoutParams logoutReq);
}
