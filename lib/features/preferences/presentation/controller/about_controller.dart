import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/update_manager.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';

class AboutController {
  late final ButtonCubit _buttonCubit;

  late final UpdateManager _updateManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
      ];

  void initialize() {
    _initializeManagers();
    _initializeCubits();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _updateManager = UpdateManager();
  }

  void _initializeCubits() {
    _buttonCubit = ButtonCubit();
  }

  UpdateManager get updateManager => _updateManager;
}
