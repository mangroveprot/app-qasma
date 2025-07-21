import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/helpers/builder_dob.dart';
import '../../../../common/utils/constant.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/toast/custom_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
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
  late final Map<String, TextEditingController> textControllers;
  late final Map<String, ValueNotifier<String?>> dropdownControllers;
  late final Map<String, dynamic> _routeData;

  @override
  void initState() {
    super.initState();
    textControllers = {
      field_firstName.field_key: TextEditingController(),
      field_lastName.field_key: TextEditingController(),
      field_suffix.field_key: TextEditingController(),
      field_middle_name.field_key: TextEditingController(),
      field_address.field_key: TextEditingController(),
      field_contact_number.field_key: TextEditingController(),
      field_email.field_key: TextEditingController(),
      field_facebook.field_key: TextEditingController(),
    };
    dropdownControllers = {
      field_gender.field_key: ValueNotifier<String?>(null),
      field_month.field_key: ValueNotifier<String?>(null),
      field_day.field_key: ValueNotifier<String?>(null),
      field_year.field_key: ValueNotifier<String?>(null),
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeData = {
      'idNumber': 'sample',
      'password': 'sample',
      'course': 'CS',
      'block': 'A',
      'yearLevel': '1',
    };
  }

  Map<String, String> _buildValidationFields() {
    final values = <String, String>{};
    for (final entry in textControllers.entries) {
      values[entry.key] = entry.value.text;
    }
    for (final entry in dropdownControllers.entries) {
      values[entry.key] = entry.value.value ?? '';
    }
    return values;
  }

  void handleSubmit() {
    // validate first
    final formCubit = context.read<FormCubit>();
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
      optionalFields: [
        field_suffix.field_key,
        field_middle_name.field_key,
        field_address.field_key,
        field_facebook.field_key,
      ],
    );

    if (!isValid) return;

    final dateOfBirth = buildDateOfBirth(
      year: dropdownControllers[field_year.field_key]!.value ?? '',
      month: dropdownControllers[field_month.field_key]!.value ?? '',
      day: dropdownControllers[field_day.field_key]!.value ?? '',
      monthsList: monthsList,
    );

    final user = UserModel(
      idNumber: _routeData['idNumber'],
      email: textControllers[field_email.field_key]!.text,
      password: _routeData['password'],
      verified: false,
      active: true,
      first_name: textControllers[field_firstName.field_key]!.text,
      last_name: textControllers[field_lastName.field_key]!.text,
      middle_name: textControllers[field_middle_name.field_key]!.text,
      suffix: textControllers[field_suffix.field_key]!.text,
      gender: dropdownControllers[field_gender.field_key]!.value ?? '',
      date_of_birth: dateOfBirth,
      address: textControllers[field_address.field_key]!.text,
      contact_number: textControllers[field_contact_number.field_key]!.text,
      facebook: textControllers[field_facebook.field_key]!.text,
      other_info: OtherInfo(
        course: _routeData['course'],
        yearLevel: _routeData['yearLevel'],
        block: _routeData['block'],
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
  void dispose() {
    for (final controller in textControllers.values) {
      controller.dispose();
    }
    for (final notifier in dropdownControllers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(leadingText: 'Back'),
      body: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonFailureState) {
            CustomToast.error(context: context, message: '2');
            CustomToast.error(context: context, message: '2');
          }
        },
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
    );
  }
}
