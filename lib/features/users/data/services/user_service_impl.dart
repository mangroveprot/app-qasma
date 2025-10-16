import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
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
  Future<Either<AppError, List<UserModel>>> getAllUser() async {
    try {
      final allUsers = await repository.getAllItems();
      return Right(allUsers);
    } catch (e, stackTrace) {
      final error = e is AppError
          ? e
          : AppError.create(
              message: 'Unexpected error during getting all users',
              type: ErrorType.unknown,
              originalError: e,
              stackTrace: stackTrace,
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
              message: 'Unexpected error during checking.',
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
      final idNumber = param.fields['idNumber'];

      if (idNumber == null) {
        return Left(AppError.create(
          message: 'ID number is required in the parameters',
          type: ErrorType.validation,
        ));
      }

      final data = Map<String, dynamic>.from(param.fields);
      data.remove('idNumber');

      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.userUpdateUrl,
        [idNumber.toString()],
      );

      final response = await _apiClient.patch(
        url,
        data: data,
        requiresAuth: false,
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
              message: 'Unexpected error during update',
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
}
