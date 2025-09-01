import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../common/error/app_error.dart';
import '../../../../common/helpers/helpers.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_repository/local_repository/local_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/user_model.dart';
import '../../domain/services/auth_service.dart';
import '../models/change_password_params.dart';
import '../models/logout_params.dart';
import '../models/resend_otp_params.dart';
import '../models/reset_password_params.dart';
import '../models/signin_params.dart';
import '../models/verify_params.dart';

class AuthServiceImpl extends BaseService<UserModel> implements AuthService {
  AuthServiceImpl(AbstractRepository<UserModel> repository) : super(repository);
  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  final _studentLocalRepo = sl<LocalRepository<UserModel>>();
  final _logger = Logger();

  @override
  Future<Either<AppError, UserModel>> signin(SigninParams signinReq) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.login,
        data: signinReq.toJson(),
        requiresAuth: false,
      );

      if (response.data['success'] == true &&
          response.data['document'] != null) {
        final document = response.data['document'] as Map<String, dynamic>;

        if (document['token'] != null) {
          final token = document['token'] as Map<String, dynamic>;
          final accessToken = token['accessToken'] as String?;
          final refreshToken = token['refreshToken'] as String?;

          if (accessToken != null) {
            await SharedPrefs().setString('accessToken', accessToken);
          }
          if (refreshToken != null) {
            await SharedPrefs().setString('refreshToken', refreshToken);
          }
        }

        if (document['user'] != null) {
          final userData = document['user'] as Map<String, dynamic>;
          final idNumber = userData['idNumber'] as String?;
          final firstName = userData['first_name'] as String?;
          if (idNumber != null) {
            await SharedPrefs().setString('currentUserId', idNumber);
          }
          await SharedPrefs()
              .setString('currentUserFirstName', firstName ?? '');

          final userModel = UserModel.fromJson(userData);

          try {
            await _studentLocalRepo.saveItem(userModel);
          } catch (e, stackTrace) {
            _logger.e('Failed to save user data locally', e, stackTrace);

            return Left(AppError.create(
              message:
                  'Something went wrong while saving your data. Please contact the administrator.',
              type: ErrorType.database,
              originalError: e,
              stackTrace: stackTrace,
            ));
          }

          return Right(userModel);
        } else {
          return Left(AppError.create(
            message: 'No user data in response',
            type: ErrorType.validation,
          ));
        }
      } else {
        return Left(AppError.create(
          message:
              'Login failed: ${response.data['message'] ?? 'Unknown error'}',
          type: ErrorType.validation,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signin',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, UserModel>> create_account(UserModel model) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.register,
        data: model.toJson(),
        requiresAuth: false,
      );

      if (response.data['success'] == true &&
          response.data['document'] != null &&
          response.data['document']['user'] != null) {
        final userJson =
            response.data['document']['user'] as Map<String, dynamic>;

        final userModel = UserModel.fromJson(userJson);

        return Right(userModel);
      } else {
        return Left(AppError.create(
          message: 'Registration failed: Missing user data',
          type: ErrorType.validation,
        ));
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signup',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> resendOTPCode(
      ResendOtpParams resendReq) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.generateOtp,
        data: resendReq.toJson(),
        requiresAuth: false,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json,
      );

      if (apiResponse.isSuccess && apiResponse.document != null) {
        return Right(apiResponse.document as Map<String, dynamic>);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signup',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> verify(VerifyParams verifyReq) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.verify,
        data: verifyReq.toJson(),
        requiresAuth: false,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json,
      );

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signup',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, Map<String, dynamic>>> forgotPassword(
    String param,
  ) async {
    final Map<String, dynamic> data;

    final isEmail = isValidEmail(param);

    if (isEmail) {
      data = {'email': param};
    } else {
      data = {'idNumber': param};
    }

    try {
      final response = await _apiClient.post(
        _urlProviderConfig.forgotPassword,
        data: data,
        requiresAuth: false,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json,
      );

      if (apiResponse.isSuccess) {
        return Right(apiResponse.document as Map<String, dynamic>);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signup',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> resetPassword(
      ResetPasswordParams resetReq) async {
    try {
      final response = await _apiClient.patch(
        _urlProviderConfig.resetPasswordUrl,
        data: resetReq.toJson(),
        requiresAuth: false,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json,
      );

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signup',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> logout(LogoutParams logoutReq) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.logoutUrl,
        data: logoutReq.toJson(),
        requiresAuth: false,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json,
      );

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signup',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> changePassword(
      ChangePasswordParams changePasswordReq) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.changePasswordUrl,
        data: changePasswordReq.toJson(),
        requiresAuth: true,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => json,
      );

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during signup',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }
}
