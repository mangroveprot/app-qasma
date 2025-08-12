import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../data/models/reset_password_params.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/reset_password_widget/reset_password_form.dart';

class ResetPassswordPage extends StatefulWidget {
  const ResetPassswordPage({super.key});

  @override
  State<ResetPassswordPage> createState() => ResetPassswordPageState();
}

class ResetPassswordPageState extends State<ResetPassswordPage> {
  static const _textFields = [
    field_password,
    field_confirm_password,
  ];

  late final Map<String, TextEditingController> textControllers;
  Map<String, dynamic>? _routeData;
  late final FormCubit formCubit;

  static const List<FormFieldConfig> _routeFields = [field_email];

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractRouteData();
  }

  void _extractRouteData() {
    if (_routeData != null) return;
    final extra = GoRouterState.of(context).extra;

    _routeData = AppRouteExtractor.extractFieldData(extra, _routeFields);
  }

  Map<String, String> _buildValidationFields() {
    final values = <String, String>{};

    for (final field in _textFields) {
      values[field.field_key] = textControllers[field.field_key]!.text;
    }

    return values;
  }

  String getRouteValue(FormFieldConfig field) {
    return _routeData?[field.field_key] ?? '';
  }

  String _getTextValue(FormFieldConfig field) {
    return textControllers[field.field_key]?.text.trim() ?? '';
  }

  void handleSubmit(BuildContext context) {
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
      // optionalFields: _optionalFields.map((field) => field.field_key).toList(),
    );

    if (!isValid) return;

    _performPasswordReset(context);
  }

  void _performPasswordReset(BuildContext context) {
    final passwordText = _getTextValue(field_password);
    final confirmPasswordText = _getTextValue(field_confirm_password);

    if (passwordText != confirmPasswordText) {
      formCubit.setFieldError(
        field_confirm_password.field_key,
        'Confirm password must be the same with password',
      );
      return;
    }

    final bool isPasswordValid = CustomPasswordFieldValidation.isValid(
      passwordText,
    );

    if (!isPasswordValid) {
      return;
    }
    final email = getRouteValue(field_email);
    final newPassword = _getTextValue(field_password);

    final user_credentials = ResetPasswordParams(
      email: email,
      newPassword: newPassword,
    );

    context.read<ButtonCubit>().execute(
          usecase: sl<ResetPasswordUsecase>(),
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
          leadingText: 'Back',
          title: 'Reset Password',
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: ResetPasswordForm(state: this),
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
        message:
            'Password reset successful! Please log in with your new password.',
        type: ToastType.success,
      );
      context.go(Routes.buildPath(Routes.aut_path, Routes.login));
    }
  }
}
