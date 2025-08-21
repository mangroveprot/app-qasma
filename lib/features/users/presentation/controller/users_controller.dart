import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/user_manager.dart';
import '../bloc/user_cubit.dart';

class UsersController {
  late final UserCubit _userCubit;
  late final UserManager _userManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<UserCubit>(
          create: (context) => _userCubit,
        ),
      ];

  void initialize() {
    _initializeManagers();
    _initializeCubits();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _userManager = UserManager();
  }

  void _initializeCubits() {
    _userCubit = UserCubit();
  }

  void _loadInitialData() {
    loadAllUsers();
  }

  Future<void> loadAllUsers() async {
    await _userManager.refreshUser(_userCubit);
  }
}
