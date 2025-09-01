import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/helpers/helpers.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../data/models/params/dynamic_param.dart';
import '../../domain/usecases/update_user_usecase.dart';

class ProfileSetupController {
  late final ButtonCubit _buttonCubit;
  final PageController pageController = PageController();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<BlocProvider> get blocProviders => [
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
      ];

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

  ProfileSetupController() {
    initialize();
  }

  void initialize({
    Function(String route, {Object? extra})? onNavigate,
  }) {
    _initializeControllers();
    _initializeCubits();
    _isInitialized = true;
  }

  void _initializeCubits() {
    _buttonCubit = ButtonCubit();
  }

  ButtonCubit get buttonCubit => _buttonCubit;
  late final Map<String, TextEditingController> textControllers;
  late final Map<String, ValueNotifier<String?>> dropdownControllers;

  void _initializeControllers() {
    textControllers = {
      for (final field in _textFields) field.field_key: TextEditingController(),
    };

    dropdownControllers = {
      for (final field in _dropdownFields)
        field.field_key: ValueNotifier<String?>(null),
    };
  }

  bool validateStep(BuildContext context, int currentStep) {
    final formCubit = context.read<FormCubit>();

    switch (currentStep) {
      case 0:
        return _validatePersonalInfo(formCubit);
      case 1:
        return _validateContactInfo(formCubit);
      default:
        return true;
    }
  }

  Map<String, String> buildValidationFields({
    required List<dynamic> fields,
    required Map<String, TextEditingController> textControllers,
    required Map<String, dynamic> dropdownControllers,
  }) {
    final values = <String, String>{};

    for (final field in fields) {
      final fieldKey = field.field_key;

      if (textControllers.containsKey(fieldKey)) {
        final value = textControllers[fieldKey]!.text;
        values[fieldKey] = value;
      } else if (dropdownControllers.containsKey(fieldKey)) {
        final value = dropdownControllers[fieldKey]?.value?.toString() ?? '';
        values[fieldKey] = value;
      }
    }

    return values;
  }

  bool _validatePersonalInfo(FormCubit formCubit) {
    final requiredKey = [
      field_firstName,
      field_lastName,
      field_gender,
      field_day,
      field_month,
      field_year,
    ];

    final optionalFields = [
      field_suffix.field_key,
      field_middle_name.field_key,
    ];

    final requiredFields = buildValidationFields(
      fields: [...requiredKey],
      dropdownControllers: dropdownControllers,
      textControllers: textControllers,
    );

    return formCubit.validateAll(
      requiredFields,
      optionalFields: optionalFields,
    );
  }

  bool _validateContactInfo(FormCubit formCubit) {
    final requiredKey = [
      field_address,
      field_contact_number,
      field_email,
    ];

    final requiredFields = buildValidationFields(
      fields: [...requiredKey],
      dropdownControllers: dropdownControllers,
      textControllers: textControllers,
    );

    return formCubit.validateAll(
      requiredFields,
    );
  }

  String getTextValue(FormFieldConfig field) {
    return textControllers[field.field_key]?.text ?? '';
  }

  String getDropdownValue(FormFieldConfig field) {
    return dropdownControllers[field.field_key]?.value ?? '';
  }

  String getFullName() {
    final firstName = getTextValue(field_firstName);
    final middleName = getTextValue(field_middle_name);
    final lastName = getTextValue(field_lastName);
    final suffix = getTextValue(field_suffix);

    return '$firstName $middleName $lastName $suffix'
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String getBirthDate() {
    final month = getDropdownValue(field_month);
    final day = getDropdownValue(field_day);
    final year = getDropdownValue(field_year);

    if (month.isEmpty || day.isEmpty || year.isEmpty) return '';
    return '$month $day, $year';
  }

  void nextStep(BuildContext context) {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousStep() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onComplete(BuildContext context) {
    _onUpdate(context);
  }

  void _onUpdate(BuildContext context) {
    final idNumber = SharedPrefs().getString('currentUserId');

    final dateOfBirth = buildDateOfBirth(
      year: getDropdownValue(field_year),
      month: getDropdownValue(field_month),
      day: getDropdownValue(field_day),
      monthsList: monthsList,
    );

    final Map<String, dynamic> data = {
      'idNumber': idNumber,
      'first_name': getTextValue(field_firstName),
      'last_name': getTextValue(field_lastName),
      'middle_name': getTextValue(field_middle_name),
      'email': getTextValue(field_email),
      'suffix': getTextValue(field_suffix),
      'gender': getDropdownValue(field_gender),
      'address': getTextValue(field_address),
      'contact_number': getTextValue(field_contact_number),
      'facebook': getTextValue(field_facebook),
      'date_of_birth': dateOfBirth.toIso8601String()
    };

    SharedPrefs()
        .setString('currentUserFirstName', getTextValue(field_firstName));

    context.read<ButtonCubit>().execute(
          usecase: sl<UpdateUserUsecase>(),
          params: DynamicParam(fields: data),
        );
  }

  void resetForm(BuildContext context) {
    textControllers.values.forEach((controller) => controller.clear());

    dropdownControllers.values.forEach((notifier) => notifier.value = null);

    context.read<FormCubit>().clearAll();

    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void disposeControllers() {
    for (final controller in textControllers.values) {
      controller.dispose();
    }
    for (final notifier in dropdownControllers.values) {
      notifier.dispose();
    }
  }
}
