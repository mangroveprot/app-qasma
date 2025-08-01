import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../common/networks/response/api_response.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/services/user_service.dart';
import '../models/user_model.dart';

class UserServiceImpl extends BaseService<UserModel> implements UserService {
  UserServiceImpl(AbstractRepository<UserModel> repository) : super(repository);
  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();

  @override
  Future<Either<AppError, bool>> isRegister(String identifier) async {
    try {
      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.isRegister,
        [identifier],
      );

      final response = await _apiClient.get(url);
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
}
