import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/services/user_service.dart';
import '../models/params/dynamic_param.dart';
import '../models/user_model.dart';

class UserServiceImpl extends BaseService<UserModel> implements UserService {
  UserServiceImpl(AbstractRepository<UserModel> repository) : super(repository);
  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();
  final _logger = Logger();

  @override
  Future<Either<AppError, bool>> isRegister(String identifier) async {
    try {
      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.isRegister,
        [identifier],
      );

      final response = await _apiClient.get(url, requiresAuth: false);
      final apiResponse = ApiResponse.fromJson(response.data, (json) => json);

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getUser',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, List<UserModel>>> getAllUser() async {
    try {
      final url = Uri.parse(_urlProviderConfig.userEndPoint).replace(
          queryParameters: {
            'query': '{"role":{"\$in":["counselor","staff"]}}'
          }).toString();

      final response = await _apiClient.get(url, requiresAuth: false);
      final apiResponse = ApiResponse.fromJson(
        response.data,
        (json) => UserModel.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.documents != null) {
        try {
          await repository.saveAllItems(apiResponse.documents!.toList());
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
        return Right(apiResponse.documents!);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getUser',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, UserModel>> getUser(String idNumber) async {
    try {
      final user = await repository.getItemById(idNumber);

      if (user == null) {
        return Left(AppError.create(
          message: 'User not found',
          type: ErrorType.notFound,
        ));
      }

      return Right(user);
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getUser',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> update(DynamicParam param) async {
    try {
      final currIdNumber = SharedPrefs().getString('currentUserId');
      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.userUpdateUrl,
        [currIdNumber ?? ''],
      );

      final response = await _apiClient.patch(
        url,
        data: param.toJson(),
        requiresAuth: true,
      );

      final apiResponse = ApiResponse.fromJson(response.data, (json) => json);

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getUser',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, List<UserModel>>> syncUser() async {
    try {
      await sync();
      final response = await getAll();
      return Right(response);
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getting all user',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }

  @override
  Future<Either<AppError, bool>> saveFcmToken(DynamicParam param) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.saveFcmToken,
        data: param.toJson(),
        requiresAuth: true,
      );

      final apiResponse = ApiResponse.fromJson(response.data, (json) => json);

      if (apiResponse.isSuccess) {
        return const Right(true);
      } else {
        return Left(apiResponse.error!);
      }
    } catch (e, stack) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during saving fcm token',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stack,
            );
      return Left(error);
    }
  }
}
