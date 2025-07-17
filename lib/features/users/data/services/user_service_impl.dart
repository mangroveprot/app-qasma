import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
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
  Future<Either> getUser(String identifier) async {
    try {
      final url = _urlProviderConfig.addPathSegments(
        _urlProviderConfig.getProfile,
        [identifier],
      );

      final response = await _apiClient.get(url);

      final data = response.data;

      return Right(data);
    } catch (e, stack) {
      final error =
          e is AppError
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
