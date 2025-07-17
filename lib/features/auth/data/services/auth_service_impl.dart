import 'package:dartz/dartz.dart';
import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../core/_base/_repository/base_repository/abstract_repositories.dart';
import '../../../../core/_base/_services/base_service/base_service.dart';
import '../../../../core/_config/url_provider.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/user_model.dart';
import '../../domain/services/auth_service.dart';
import '../models/signin_params.dart';

class AuthServiceImpl extends BaseService<UserModel> implements AuthService {
  AuthServiceImpl(AbstractRepository<UserModel> repository) : super(repository);
  final ApiClient _apiClient = sl<ApiClient>();
  final URLProviderConfig _urlProviderConfig = sl<URLProviderConfig>();

  @override
  Future<Either> signin(SigninParams signinReq) async {
    try {
      final response = await _apiClient.post(
        _urlProviderConfig.login,
        data: signinReq.toJson(),
      );
      return Right(response);
    } catch (e, stack) {
      final error =
          e is AppError
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
}
