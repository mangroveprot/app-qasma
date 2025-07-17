import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/button/custom_app_button.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/custom_dropdown_field.dart';
import '../../../../common/widgets/custom_form_field.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../users/domain/usecases/get_profile_usecase.dart';
import '../widgets/call_to_action.dart';
import '../widgets/signup_header.dart';

class GetStartedPage extends StatefulWidget {
  GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final _idNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _courseController = ValueNotifier<String?>(null);
  final _blockController = ValueNotifier<String?>(null);
  final _yearLevelController = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _idNumberController.dispose();
    _courseController.dispose();
    _blockController.dispose();
    _yearLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(leadingText: 'Back'),
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            context.go('/auth/create-account');
          }
          if (state is ButtonFailureState) {
            final snackBar = SnackBar(content: Text(state.errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SignupHeader(headingTitle: 'Get Started!'),
                const SizedBox(height: 20),
                CustomFormField(
                  name: 'ID Number',
                  required: true,
                  hint: 'Enter your id number...',
                  controller: _idNumberController,
                ),
                const SizedBox(height: 16),
                CustomDropdownField(
                  hint: 'Select a course...',
                  required: true,
                  name: 'Course',
                  controller: _courseController,
                  items: ['Male', 'Female'],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustomDropdownField(
                      name: 'Bloc',
                      required: true,
                      showErrorText: false,
                      controller: _blockController,
                      hint: 'select...',
                      items: [],
                    ),
                    const SizedBox(width: 12),
                    CustomDropdownField(
                      name: 'Year Level',
                      controller: _yearLevelController,
                      required: true,
                      showErrorText: false,
                      hint: 'select...',
                      items: [],
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  name: 'Password',
                  required: true,
                  hint: 'Enter your password...',
                  controller: _passwordController,
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  name: 'Confirm Password',
                  required: true,
                  hint: 'Re-enter your password...',
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 16),
                CustomAppButton(
                  buttonText: 'Next',
                  textDecoration: TextDecoration.underline,
                  fontWeight: context.weight.medium,
                  iconData: Icons.arrow_forward,
                  iconPosition: Position.right,
                  mainAxisAlignment: MainAxisAlignment.end,
                  onPressed: () {
                    final formCubit = context.read<FormCubit>();
                    final isValid = formCubit.validateAll({
                      'ID Number': _idNumberController.text,
                      'Password': _passwordController.text,
                      'Confirm Password': _confirmPasswordController.text,
                      // 'Couese': _courseController.value ?? '',
                      // 'Block': _blockController.value ?? '',
                    });
                    if (isValid) {
                      context.read<ButtonCubit>().execute(
                        usecase: sl<GetProfileUsecase>(),
                        params: _idNumberController.text,
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                const CallToAction(
                  actionText: 'Already have an acount? ',
                  actionLabel: 'Login',
                  directionPath: '/auth/test',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
