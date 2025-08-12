import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/constant.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
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
    return textControllers[field.field_key]?.text.trim() ?? '';
  }

  void handleSubmit(BuildContext context) {
    final isValid = formCubit.validateAll(_buildValidationFields());

    if (!isValid) return;

    _performLogin(context);
  }

  void _performLogin(BuildContext context) {
    final emailorIdNumber = _getTextValue(field_idNumber_email);
    context.read<ButtonCubit>().execute(
          usecase: sl<ForgotPasswordUsecase>(),
          params: emailorIdNumber,
          // buttonId: ButtonsUniqeKeys.forgotPassword.id,
        );
  }

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
          AppToast.show(
            message: message,
            type: ToastType.error,
          );
          await Future.delayed(const Duration(milliseconds: 1500));
        }
      });
    }
    if (state is ButtonSuccessState) {
      final dynamic rawData = state.data;
      final accountVerification = OtpPurposes.passwordReset;

      if (rawData != null && rawData is Map<String, dynamic>) {
        final email = rawData['email'];
        context.push(
          Routes.buildPath(Routes.aut_path, Routes.otp_verification),
          extra: {
            field_email.field_key: email,
            accountVerification: accountVerification,
          },
        );
      }
    }
  }
}
