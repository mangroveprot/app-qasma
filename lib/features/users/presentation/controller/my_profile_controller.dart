import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';

import '../../../../common/manager/user_manager.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../data/models/params/dynamic_param.dart';
import '../bloc/user_cubit.dart';

class MyProfileController {
  late final ButtonCubit _buttonCubit;
  late final UserCubit _userCubit;
  late final String _currentUserId;

  late final UserManager _userManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<UserCubit>(
          create: (context) => _userCubit,
        ),
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
      ];

  void initialize({Function(String route, {Object? extra})? onNavigate}) {
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
    _buttonCubit = ButtonCubit();
    _currentUserId = SharedPrefs().getString('currentUserId') ?? '';
  }

  void _loadInitialData() {
    _loadUserData();
  }

  ButtonCubit get buttonCubit => _buttonCubit;

  UserCubit get userCubit => _userCubit;

  void _loadUserData() {
    _userManager.loadUser(_currentUserId, _userCubit);
  }

  Future<void> refreshUser() async {
    await _userManager.refreshUser(_userCubit);
  }

  void updateUser(DynamicParam param) {
    _userManager.updateUser(param, _buttonCubit);
  }
}
