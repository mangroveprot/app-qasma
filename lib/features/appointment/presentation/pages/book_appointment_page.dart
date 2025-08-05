import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../widgets/book_appointment_widget/book_appointment_form.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => BookAppointmentPageState();
}

class BookAppointmentPageState extends State<BookAppointmentPage> {
  static const _textFields = [];

  static const _dropdownFields = [
    field_appointmentDateTime,
    field_appointmentType
  ];

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

  String? get category {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    return extra?['category'] as String?;
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

  List<String> getCategories() {
    final configCubit = context.read<AppointmentConfigCubit>();
    return configCubit.allCategories;
  }

  // helpers
  String _getTextValue(FormFieldConfig field) {
    return textControllers[field.field_key]?.text ?? '';
  }

  String _getDropdownValue(FormFieldConfig field) {
    return dropdownControllers[field.field_key]?.value ?? '';
  }

  void handleSubmit() {
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
      // optionalFields: _optionalFields.map((field) => field.field_key).toList(),
    );

    if (!isValid) return;

    _performBooking();
  }

  void _performBooking() {
    print('Saving appointment....');
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
                child: BookAppointmentForm(
                  state: this,
                ),
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
  ) async {}
}
