import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';

class QRScannerController {
  late final ButtonCubit _buttonCubit;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
      ];

  void initialize() {
    _initializeCubits();
    _isInitialized = true;
  }

  void _initializeCubits() {
    _buttonCubit = ButtonCubit();
  }

  ButtonCubit get buttonCubit => _buttonCubit;
}
