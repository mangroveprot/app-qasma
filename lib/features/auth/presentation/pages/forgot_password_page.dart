import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/custom_toast.dart';
import '../widgets/forgot_password_widget/forgot_password_form.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static const _textFields = [field_idNumber_email];

  late final Map<String, TextEditingController> textControllers;
  late final FormCubit formCubit;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    formCubit = context.read<FormCubit>();
  }

  void _initializeControllers() {
    textControllers = {
      for (final field in _textFields) field.field_key: TextEditingController(),
    };
  }

  Map<String, String> _buildValidationFields() {
    final values = <String, String>{};

    // add text field values
    for (final field in _textFields) {
      values[field.field_key] = textControllers[field.field_key]!.text;
    }

    return values;
  }

  String _getTextValue(FormFieldConfig field) {
    return textControllers[field.field_key]?.text ?? '';
  }

  void handleSubmit() {
    final isValid = formCubit.validateAll(_buildValidationFields());

    if (!isValid) return;

    _performLogin();
  }

  void _performLogin() {}

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final controller in textControllers.values) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Scaffold(
        appBar: const CustomAppBar(
          leadingText: 'Back',
          title: 'Forgot Pasword',
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: ForgotPasswordForm(state: this),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonState(
    BuildContext context,
    ButtonState state,
  ) async {
    if (state is ButtonFailureState) {
      Future.microtask(() async {
        for (final message in state.errorMessages) {
          CustomToast.error(context: context, message: message);
          await Future.delayed(const Duration(milliseconds: 1500));
        }
      });
    }
    if (state is ButtonSuccessState) {}
  }
}
