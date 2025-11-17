import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helpers/helpers.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../data/models/signin_params.dart';
import '../../domain/usecases/signin_usecase.dart';
import '../widgets/login_widget/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static const _textFields = [field_idNumber, field_password];

  late final Map<String, TextEditingController> textControllers;
  late final FormCubit formCubit;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    textControllers = {
      for (final field in _textFields) field.field_key: TextEditingController(),
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formCubit = context.read<FormCubit>();
  }

  Map<String, String> _buildValidationFields() {
    final values = <String, String>{};

    for (final field in _textFields) {
      values[field.field_key] = textControllers[field.field_key]!.text.trim();
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
    FocusScope.of(context).unfocus();
    final password = _getTextValue(field_password);
    final isValid = isPasswordValid(password);

    if (!isValid) {
      formCubit.setFieldError(
        field_password.field_key,
        'Password must be at least 8 characters long',
      );
      return;
    }

    final user_credentials = SigninParams(
        idNumber: _getTextValue(field_idNumber),
        password: _getTextValue(field_password));

    context
        .read<ButtonCubit>()
        .execute(usecase: sl<SigninUsecase>(), params: user_credentials);
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
    return Scaffold(
      body: BlocProvider(
        create: (_) => ButtonCubit(),
        child: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: SafeArea(
            child: LoginForm(state: this),
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonState(
      BuildContext context, ButtonState state) async {
    if (state is ButtonSuccessState) {
      return context.go(Routes.root);
    }
  }
}
