import 'package:dartz/dartz.dart';

import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../appointment/domain/usecases/getall_appointments_usecase.dart';
import '../../../appointment_config/domain/usecases/get_config_usecase.dart';
import '../../../users/data/models/user_model.dart';
import '../../domain/repository/auth_repositories.dart';
import '../../domain/services/auth_service.dart';
import '../models/signin_params.dart';

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
      _preloadAppointmentsAndConfig();
    }

    return result;
  }

  void _preloadAppointmentsAndConfig() {
    Future.microtask(() async {
      try {
        final userId = SharedPrefs().getString('currentUserId');
        if (userId != null) {
          final appointmentUseCase = sl<GetAllAppointmentUsecase>();
          await appointmentUseCase.call();
          final configUseCase = sl<GetConfigUseCase>();
          await configUseCase.call();
        }
      } catch (e) {}
    });
  }
}
