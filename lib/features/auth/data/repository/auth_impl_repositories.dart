import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../../appointment_config/domain/usecases/get_config_usecase.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/domain/usecases/get_all_user_usecase.dart';
import '../../domain/repository/auth_repositories.dart';
import '../../domain/services/auth_service.dart';
import '../models/change_password_params.dart';
import '../models/logout_params.dart';
import '../models/resend_otp_params.dart';
import '../models/reset_password_params.dart';
import '../models/signin_params.dart';
import '../models/verify_params.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService = sl<AuthService>();
  @override
  Future<Either> signup(UserModel model) async {
    final Either result = await _authService.create_account(model);
    return result;
  }

  @override
  Future<Either> signin(SigninParams signinReq) async {
    final Either result = await _authService.signin(signinReq);

    if (result.isRight()) {
      _preloadData();
    }

    return result;
  }

  void _preloadData() {
    Future.microtask(() async {
      final userId = SharedPrefs().getString('currentUserId');
      if (userId != null) {
        await Future.wait([
          sl<GetAllAppointmentsUsecase>().call(),
          sl<GetConfigUseCase>().call(),
          sl<GetAllUserUsecase>().call(),
        ]);
      }
    });
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> resendOTPCode(
      ResendOtpParams resendReq) async {
    final Either result = await _authService.resendOTPCode(resendReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, bool>> verify(VerifyParams verifyReq) async {
    final Either result = await _authService.verify(verifyReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> forgotPassword(
      String param) async {
    final Either result = await _authService.forgotPassword(param);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, bool>> resetPassword(
      ResetPasswordParams resetReq) async {
    final Either result = await _authService.resetPassword(resetReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, bool>> changePassword(
      ChangePasswordParams changePasswordReq) async {
    final Either result = await _authService.changePassword(changePasswordReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<Either<AppError, bool>> logout(LogoutParams logoutReq) async {
    final Either result = await _authService.logout(logoutReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
