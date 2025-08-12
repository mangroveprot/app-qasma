import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../controller/my_profile_controller.dart';
import '../widgets/my_profile_widget/my_profile_form.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  late final MyProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = MyProfileController();
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            title: 'My Profile',
            onBackPressed: _handleBack,
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: MyProfileForm(state: this),
            );
          }),
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
    }
    if (state is ButtonSuccessState) {}
  }

  Future<void> _handleBack(BuildContext context) async {
    if (context.mounted) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final onSuccess = extra?['onSuccess'] as Function()?;

      if (onSuccess != null) {
        try {
          await onSuccess();
        } catch (e) {
          debugPrint('Error calling success callback: $e');
        }
      }
      context.pop();
    }
  }
}
