import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../domain/usecases/is_active.dart';
import '../bloc/user_cubit.dart';
import '../controller/activation_controller.dart';
import '../widgets/activation_widget/activation_contact_section.dart';
import '../widgets/activation_widget/activation_header.dart';
import '../widgets/activation_widget/activation_instructions_card.dart';
import '../widgets/activation_widget/activation_logout_button.dart';
import '../widgets/activation_widget/activation_qr_section.dart';
import '../widgets/activation_widget/activation_steps.dart';

class ActivationPage extends StatefulWidget {
  const ActivationPage({super.key});

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  late final ActivationController controller;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    controller = ActivationController();
  }

  @override
  Widget build(BuildContext context) {
    controller.initialize(context: context);
    if (!controller.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
        child: BlocBuilder<UserCubit, UserCubitState>(
          builder: (context, userState) {
            final user = controller.currentUserProfile();
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ActivationHeader(),
                      ActivationQRSection(
                        studentId: user?.idNumber ?? '',
                        isRefreshing: _isRefreshing,
                        onRefresh: () => _handleRefresh(context),
                      ),
                      Column(
                        children: [
                          const ActivationInstructionsCard(),
                          const SizedBox(height: 8),
                          const ActivationSteps(),
                          const SizedBox(height: 8),
                          ActivationLogoutButton(
                            controller: controller,
                          ),
                          const SizedBox(height: 8),
                          const ActivationContactSection(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    await context.read<ButtonCubit>().execute(
          usecase: sl<IsActiveUsecase>(),
        );

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonSuccessState) {
      final isActive = state.data ?? false;

      if (isActive) {
        SharedPrefs().setBool('isActive', isActive);
        AppToast.show(
          message: 'Your account has been registered successfully!',
          type: ToastType.success,
        );
        Future.delayed(const Duration(seconds: 2));
        context.go(Routes.root);
        return;
      } else {
        AppToast.show(
          message:
              'Account activation is still required. Please present your QR code to the guidance office staff.',
          type: ToastType.warning,
          duration: const Duration(seconds: 4),
        );
        return;
      }
    }

    if (state is ButtonFailureState) {
      if (state.errorMessages.isNotEmpty) {
        AppToast.show(
          message: state.errorMessages.first,
          type: ToastType.error,
        );
      }
    }
  }
}
