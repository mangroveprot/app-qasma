import '../../features/users/domain/usecases/get_user_usecase.dart';
import '../../features/users/presentation/bloc/user_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';

class UserManager {
  late final GetUserUsecase _getUserUseCase;

  UserManager() {
    _getUserUseCase = sl<GetUserUsecase>();
  }

  void loadUser(String userId, UserCubit cubit) {
    cubit.loadUser(
      idNumber: userId,
      usecase: _getUserUseCase,
    );
  }
}
