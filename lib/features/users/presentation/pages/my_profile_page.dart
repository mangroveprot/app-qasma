import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../controller/my_profile_controller.dart';
import '../widgets/my_profile_widget/my_profile_form.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  late final MyProfileController controller;
  Map<String, dynamic>? _routeData;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = MyProfileController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitialized) {
      //  final rawExtra = GoRouterState.of(context).extra;

      _extractRouteData();

      controller.initialize(idNumber: idNumber ?? '');
      _hasInitialized = true;
    }
  }

  void _extractRouteData() {
    if (_routeData != null) return;

    final rawExtra = GoRouterState.of(context).extra;

    _routeData = rawExtra as Map<String, dynamic>?;

    if (_routeData == null) {
      _routeData = AppRouteExtractor.extractRaw<Map<String, dynamic>>(rawExtra);
    }
  }

  String? get idNumber => _routeData?['idNumber'] as String?;
  bool get isCurrentUser => _routeData?['isCurrentUser'] as bool? ?? false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ButtonCubit, ButtonState>(
            listener: _handleButtonState,
          ),
        ],
        child: Scaffold(
          appBar: CustomAppBar(
            title: isCurrentUser ? 'My Profile' : 'User Profile',
            onBackPressed: _handleBack,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: MyProfileForm(state: this),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonState(
      BuildContext context, ButtonState state) async {
    if (state is ButtonFailureState) {
      Future.microtask(() async {
        for (final message in state.errorMessages) {
          AppToast.show(
            message: message,
            type: ToastType.error,
          );
          await Future.delayed(const Duration(milliseconds: 1500));
        }
      });

      for (final suggestion in state.suggestions) {
        AppToast.show(
          message: suggestion,
          type: ToastType.original,
        );
        await Future.delayed(const Duration(milliseconds: 2000));
      }
    }
    if (state is ButtonSuccessState) {}
  }

  Future<void> _handleBack(BuildContext context) async {
    if (context.mounted) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final onSuccess = extra?['onSuccess'] as Function()?;

      if (onSuccess != null) {
        try {
          onSuccess();
        } catch (e) {
          debugPrint('Error calling success callback: $e');
        }
      }
      context.pop();
    }
  }
}
