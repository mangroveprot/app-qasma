import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';

import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../domain/usecases/is_register_usecase.dart';
import '../controller/profile_setup_controller.dart';
import '../widgets/profile_setup_widget/profile_setup_form.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => ProfileSetupPageState();
}

class ProfileSetupPageState extends State<ProfileSetupPage> {
  static const int _totalSteps = 3;

  int get totalSteps => _totalSteps;

  int currentStep = 0;
  // bool _isComplete = false;
  late ProfileSetupController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfileSetupController();
  }

  @override
  void deactivate() {
    context.read<FormCubit>().clearAll();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.disposeControllers();
    super.dispose();
  }

  Future<void> nextStep(BuildContext context) async {
    final email = controller.getTextValue(field_email);
    final cubit = context.read<ButtonCubit>();
    FocusScope.of(context).unfocus();

    if (email.isNotEmpty) {
      cubit.emitLoading();
      final result = await sl<IsRegisterUsecase>().call(param: email);

      return result.fold((error) {
        cubit.emitInitial();
        return AppToast.show(
            message: error.message ?? error.errorMessages.first,
            type: ToastType.error);
      }, (isNotRegistered) {
        cubit.emitInitial();

        if (!isNotRegistered) {
          return AppToast.show(
            message: 'This email is already registered.',
            type: ToastType.cancel,
          );
        }

        if (controller.validateStep(context, currentStep)) {
          if (currentStep < _totalSteps - 1) {
            setState(() {
              currentStep++;
            });
            controller.nextStep(context);
          }
        }
      });
    }

    if (controller.validateStep(context, currentStep)) {
      if (currentStep < _totalSteps - 1) {
        setState(() {
          currentStep++;
        });
        controller.nextStep(context);
      }
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      controller.previousStep();
    }
  }

  void completeSetup(BuildContext context) {
    setState(() {
      //   _isComplete = true;
    });
    controller.onComplete(context);
  }

  void resetForm() {
    setState(() {
      // _isComplete = false;
      currentStep = 0;
    });
    controller.resetForm(context);
  }

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
          body: SafeArea(
            child: PagesetupForm(
              state: this,
            ),
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
    if (state is ButtonSuccessState) {
      final hasFirstName =
          SharedPrefs().getString('currentUserFirstName') ?? '';
      if (hasFirstName.isNotEmpty) {
        return context.go(Routes.root);
      }
    }
  }
}
