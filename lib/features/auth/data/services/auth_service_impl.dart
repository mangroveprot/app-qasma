import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../../../common/error/app_error.dart';
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
import '../models/signin_params.dart';

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
          if (idNumber != null) {
            await SharedPrefs().setString('currentUserId', idNumber);
          }
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
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => UserModel.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.document != null) {
        return Right(apiResponse.document as UserModel);
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
