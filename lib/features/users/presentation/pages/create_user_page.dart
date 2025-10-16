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
import '../../../auth/domain/usecases/signup_usecase.dart';
import '../../data/models/other_info_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/is_register_usecase.dart';
import '../widgets/create_user_widget/create_user_form.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => CreateUserPageState();
}

class CreateUserPageState extends State<CreateUserPage> {
  static const _textFields = [field_idNumber, field_password];

  late final Map<String, TextEditingController> textControllers;
  late final FormCubit formCubit;
  Map<String, dynamic>? _routeData;

  @override
  void initState() {
    super.initState();

    _initializeControllers();
    formCubit = context.read<FormCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _extractRouteData();
  }

  void _extractRouteData() {
    if (_routeData != null) return;

    final rawExtra = GoRouterState.of(context).extra;

    _routeData = rawExtra as Map<String, dynamic>?;

    if (_routeData == null) {
      _routeData = AppRouteExtractor.extractRaw<Map<String, dynamic>>(rawExtra);
    }
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

  String? get role {
    if (_routeData == null) {
      _extractRouteData();
    }
    return _routeData?['role'] as String?;
  }

  void handleSubmit(BuildContext context) {
    final isValid = formCubit.validateAll(_buildValidationFields());

    if (!isValid) return;

    _performCreateUser(context);
  }

  Future<void> _performCreateUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final idNumber = _getTextValue(field_idNumber);
    final password = _getTextValue(field_password);

    context.read<ButtonCubit>().emitLoading();

    final isAlreadyRegistered = await _checkIfIdNumberExists(idNumber);
    if (!isAlreadyRegistered) {
      context.read<ButtonCubit>().emitError(
        errorMessages: [
          'This ID number is already registered. Please use a different ID number.'
        ],
      );
      return;
    }

    if (role?.isEmpty ?? true) {
      context.read<ButtonCubit>().emitError(
        errorMessages: [
          'User role not found. Please go back to the previous page and try again.'
        ],
      );
      return;
    }

    final otherInfo = _createOtherInfoForRole(role!);

    final userModel = UserModel(
      idNumber: idNumber,
      email: '$idNumber@example.com',
      password: password,
      role: role!,
      verified: true,
      active: true,
      first_name: '',
      last_name: '',
      middle_name: '',
      suffix: '',
      gender: 'other',
      date_of_birth: DateTime.now().subtract(const Duration(days: 365 * 20)),
      address: '',
      contact_number: '',
      facebook: '',
      other_info: otherInfo,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    context.read<ButtonCubit>().execute(
          usecase: sl<SignupUsecase>(),
          params: userModel,
        );
  }

  Future<bool> _checkIfIdNumberExists(String idNumber) async {
    final result = await sl<IsRegisterUsecase>().call(param: idNumber);

    return result.fold(
      (error) {
        return false;
      },
      (isRegistered) => isRegistered,
    );
  }

  OtherInfoModel _createOtherInfoForRole(String role) {
    final normalizedRole = role.toLowerCase();

    switch (normalizedRole) {
      case 'student':
        return const OtherInfoModel({
          'course': '',
          'yearLevel': '1',
          'block': '',
        });
      case 'counselor':
        return const OtherInfoModel({
          'unavailableTimes': {},
        });
      case 'staff':
      default:
        return const OtherInfoModel({});
    }
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
        appBar: CustomAppBar(
          onBackPressed: _handleBack,
        ),
        body: BlocListener<ButtonCubit, ButtonState>(
          listener: _handleButtonState,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: CreateUserForm(state: this),
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
        message: 'New ${role} is created successfully!',
        type: ToastType.success,
      );

      if (context.canPop()) {
        context.pop();
      }
    }
  }

  Future<void> _handleBack(BuildContext context) async {
    if (context.mounted) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final onSuccess = extra?['onSuccess'] as Function()?;

      if (onSuccess != null) {
        try {
          onSuccess();
        } catch (e) {
          debugPrint('Error calling success callback: $e');
        }
      }
      context.pop();
    }
  }
}
