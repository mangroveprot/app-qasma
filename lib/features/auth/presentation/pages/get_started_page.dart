import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../users/domain/usecases/is_register_usecase.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/get_started_widget/get_started_form.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => GetStartedPageState();
}

class GetStartedPageState extends State<GetStartedPage> {
  static const _textFields = [
    field_idNumber,
    field_password,
    field_confirm_password,
  ];

  static const _dropdownFields = [field_course, field_block, field_year_level];

  late final Map<String, TextEditingController> textControllers;
  late final Map<String, ValueNotifier<String?>> dropdownControllers;
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

    dropdownControllers = {
      for (final field in _dropdownFields)
        field.field_key: ValueNotifier<String?>(null),
    };
  }

  Map<String, String> _buildValidationFields() {
    final values = <String, String>{};

    // add text field values
    for (final field in _textFields) {
      values[field.field_key] = textControllers[field.field_key]!.text;
    }

    // add dropdown field values
    for (final field in _dropdownFields) {
      values[field.field_key] =
          dropdownControllers[field.field_key]!.value ?? '';
    }

    return values;
  }

  // helpers
  String _getTextValue(FormFieldConfig field) {
    return textControllers[field.field_key]?.text.trim() ?? '';
  }

  String _getDropdownValue(FormFieldConfig field) {
    return dropdownControllers[field.field_key]?.value?.trim() ?? '';
  }

  void handleSubmit(BuildContext context) {
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
      // optionalFields: _optionalFields.map((field) => field.field_key).toList(),
    );

    if (!isValid) return;

    _performValidation(context);
  }

  void _performValidation(BuildContext context) {
    final passwordText = _getTextValue(field_password);
    final confirmPasswordText = _getTextValue(field_confirm_password);
    final idNumberText = _getTextValue(field_idNumber);

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

    context.read<ButtonCubit>().execute(
          usecase: sl<IsRegisterUsecase>(),
          params: idNumberText,
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
    for (final notifier in dropdownControllers.values) {
      notifier.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Scaffold(
        appBar: const CustomAppBar(
          leadingText: 'Back',
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: GetStartedForm(state: this),
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
      context.push(
        Routes.buildPath(Routes.aut_path, Routes.create_account),
        extra: {
          field_idNumber.field_key: _getTextValue(field_idNumber),
          field_password.field_key: _getTextValue(field_password),
          field_course.field_key: _getDropdownValue(field_course),
          field_block.field_key: _getDropdownValue(field_block),
          field_year_level.field_key: _getDropdownValue(field_year_level),
        },
      );
    }
  }
}
