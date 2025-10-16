import '../../features/users/data/models/params/dynamic_param.dart';
import '../../features/users/domain/usecases/get_all_user_usecase.dart';
import '../../features/users/domain/usecases/get_user_usecase.dart';
import '../../features/users/domain/usecases/sync_user_usecase.dart';
import '../../features/users/domain/usecases/update_user_usecase.dart';
import '../../features/users/presentation/bloc/user_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';
import '../widgets/bloc/button/button_cubit.dart';

class UserManager {
  late final GetUserUsecase _getUserUseCase;
  late final GetAllUserUsecase _getAllUserUseCase;
  late final UpdateUserUsecase _updateUserUsecase;
  late final SyncUserUsecase _syncUserUsecase;

  UserManager() {
    _getUserUseCase = sl<GetUserUsecase>();
    _getAllUserUseCase = sl<GetAllUserUsecase>();
    _updateUserUsecase = sl<UpdateUserUsecase>();
    _syncUserUsecase = sl<SyncUserUsecase>();
  }

  void loadAllUser(UserCubit cubit) {
    refreshUser(cubit);
  }

  void getUserProfile(UserCubit cubit, String idNumber) {
    cubit.loadUser(
      usecase: _getUserUseCase,
      params: idNumber,
    );
  }

  void updateUser(DynamicParam param, ButtonCubit cubit) {
    cubit.execute(
      usecase: _updateUserUsecase,
      params: param,
    );
  }

  Future<void> refreshUser(UserCubit cubit) async {
    await cubit.refreshUser(
      usecase: _syncUserUsecase,
    );
  }
}
