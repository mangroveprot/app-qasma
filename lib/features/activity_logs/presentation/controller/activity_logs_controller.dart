import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/user_manager.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../../../users/presentation/bloc/user_cubit_extensions.dart';
import '../../domain/usecases/get_activity_logs_by_user_usecase.dart';
import '../bloc/activity_logs_cubit.dart';

class ActivityLogsController {
  late final ActivityLogsCubit _activityLogsCubit;
  late final UserCubit _userCubit;
  late final UserManager _userManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<ActivityLogsCubit>(
          create: (context) => _activityLogsCubit,
        ),
        BlocProvider<UserCubit>(
          create: (context) => _userCubit,
        ),
      ];

  void initialize() {
    _initializeCubits();
    _initializeManagers();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeCubits() {
    _activityLogsCubit = ActivityLogsCubit();
    _userCubit = UserCubit();
  }

  void _initializeManagers() {
    _userManager = UserManager();
  }

  void _loadInitialData() {
    refreshActivityLogs(forceRefresh: true);
    _userManager.refreshUser(_userCubit);
  }

  List<UserModel>? getUsers() => _userCubit.getAllUser();

  Future<void> refreshActivityLogs({bool forceRefresh = true}) async {
    await _activityLogsCubit.loadActivityLogs(
      params: {
        'page': 1,
        'limit': 20,
        'forceRefresh': forceRefresh,
      },
      usecase: sl<GetActivityLogsByUserUsecase>(),
    );
  }

  Future<void> loadMore() async {
    await _activityLogsCubit.loadMore(
      usecase: sl<GetActivityLogsByUserUsecase>(),
    );
  }

  void dispose() {
    _activityLogsCubit.close();
  }
}
