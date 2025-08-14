import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/change_password_params.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../widgets/change_password_widget/change_password_form.dart';
import '../widgets/custom_password_field.dart';

class ChangePassswordPage extends StatefulWidget {
  const ChangePassswordPage({super.key});

  @override
  State<ChangePassswordPage> createState() => ChangePassswordPageState();
}

class ChangePassswordPageState extends State<ChangePassswordPage> {
  static const _textFields = [
    field_current_password,
    field_password,
    field_confirm_password,
  ];

  late final Map<String, TextEditingController> textControllers;
  late final FormCubit formCubit;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FormCubit>().clearAll();
    });
    formCubit = context.read<FormCubit>();
  }

  void _initializeControllers() {
    textControllers = {
      for (final field in _textFields) field.field_key: TextEditingController(),
    };
  }

  Map<String, String> _buildValidationFields() {
    final values = <String, String>{};

    for (final field in _textFields) {
      values[field.field_key] = textControllers[field.field_key]!.text;
    }

    return values;
  }

  String _getTextValue(FormFieldConfig field) {
    return textControllers[field.field_key]?.text.trim() ?? '';
  }

  void handleSubmit(BuildContext context) {
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
    );

    if (!isValid) return;

    _performChangePaswword(context);
  }

  void _performChangePaswword(BuildContext context) {
    final currUserId = SharedPrefs().getString('currentUserId');
    final passwordText = _getTextValue(field_password);
    final confirmPasswordText = _getTextValue(field_confirm_password);
    final currentPassword = _getTextValue(field_current_password);

    if (passwordText != confirmPasswordText) {
      formCubit.setFieldError(
        field_confirm_password.field_key,
        'Confirm password must be the same with password',
      );
      return;
    }

    if (passwordText == currentPassword) {
      formCubit.setFieldError(
        field_password.field_key,
        'New password must be different from current password.',
      );
      return;
    }

    final bool isPasswordValid = CustomPasswordFieldValidation.isValid(
      passwordText,
    );

    if (!isPasswordValid) {
      return;
    }

    final user_credentials = ChangePasswordParams(
      idNumber: currUserId ?? '',
      currentPassword: currentPassword,
      newPassword: passwordText,
    );

    context.read<ButtonCubit>().execute(
          usecase: sl<ChangePasswordUsecase>(),
          params: user_credentials,
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
          title: 'Change Password',
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: ChangePasswordForm(state: this),
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
      AppToast.show(
        message: 'Password change successfully!',
        type: ToastType.success,
      );
      context.pop();
    }
  }
}
