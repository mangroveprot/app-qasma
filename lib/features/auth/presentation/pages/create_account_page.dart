import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helpers/helpers.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../../theme/theme_extensions.dart';
import '../../../users/domain/entities/other_info.dart';
import '../../../users/data/models/user_model.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../widgets/create_account_widget/create_account_form.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  static const _textFields = [
    field_firstName,
    field_lastName,
    field_suffix,
    field_middle_name,
    field_address,
    field_contact_number,
    field_email,
    field_facebook,
  ];

  static const _dropdownFields = [
    field_gender,
    field_month,
    field_day,
    field_year,
  ];

  static const _routeFields = [
    field_idNumber,
    field_password,
    field_course,
    field_block,
    field_year_level,
  ];

  static const _optionalFields = [
    field_suffix,
    field_middle_name,
    field_address,
    field_facebook,
  ];

  late final Map<String, TextEditingController> textControllers;
  late final Map<String, ValueNotifier<String?>> dropdownControllers;
  Map<String, dynamic>? _routeData;
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

    dropdownControllers = {
      for (final field in _dropdownFields)
        field.field_key: ValueNotifier<String?>(null),
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
    if (extra != null && extra is Map<String, dynamic>) {
      _routeData = {
        for (final field in _routeFields)
          field.field_key: extra[field.field_key] ?? '',
      };
    } else {
      _routeData = {for (final field in _routeFields) field.field_key: ''};
    }
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

  String _getTextValue(FormFieldConfig field) {
    return textControllers[field.field_key]?.text ?? '';
  }

  String _getDropdownValue(FormFieldConfig field) {
    return dropdownControllers[field.field_key]?.value ?? '';
  }

  String _getRouteValue(FormFieldConfig field) {
    return _routeData?[field.field_key] ?? '';
  }

  void handleSubmit(BuildContext context) {
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
      optionalFields: _optionalFields.map((field) => field.field_key).toList(),
    );

    if (!isValid) return;

    _performSignup(context);
  }

  void _performSignup(BuildContext context) {
    final dateOfBirth = buildDateOfBirth(
      year: _getDropdownValue(field_year),
      month: _getDropdownValue(field_month),
      day: _getDropdownValue(field_day),
      monthsList: monthsList,
    );

    final user = UserModel(
      idNumber: _getRouteValue(field_idNumber),
      email: _getTextValue(field_email),
      password: _getRouteValue(field_password),
      verified: false,
      active: true,
      first_name: _getTextValue(field_firstName),
      last_name: _getTextValue(field_lastName),
      middle_name: _getTextValue(field_middle_name),
      suffix: _getTextValue(field_suffix),
      gender: _getDropdownValue(field_gender),
      date_of_birth: dateOfBirth,
      address: _getTextValue(field_address),
      contact_number: _getTextValue(field_contact_number),
      facebook: _getTextValue(field_facebook),
      other_info: OtherInfo(
        course: _getRouteValue(field_course),
        yearLevel: _getRouteValue(field_year_level),
        block: _getRouteValue(field_block),
      ),
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    context.read<ButtonCubit>().execute(
          usecase: sl<SignupUsecase>(),
          params: user,
        );
  }

  @override
  void deactivate() {
    context.read<FormCubit>().clearAll();
    super.deactivate();
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
        appBar: CustomAppBar(
          backgroundColor: context.colors.background,
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: CreateAccountForm(state: this),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonFailureState) {
      if (state.errorMessages.isNotEmpty) {
        AppToast.show(
          message: state.errorMessages.first,
          type: ToastType.error,
        );
      }
    }

    if (state is ButtonSuccessState) {
      final data = state.data;
      final accountVerification = OtpPurposes.accountVerification;

      if (data is UserModel) {
        context.push(
          Routes.buildPath(Routes.aut_path, Routes.otp_verification),
          extra: {
            field_email.field_key: data.email,
            accountVerification: accountVerification
          },
        );
      }
    }
  }
}
