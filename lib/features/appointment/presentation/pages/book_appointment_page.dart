import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/helpers/helpers.dart';
import '../../../../common/utils/form_field_config.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';

import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_routes.dart';
import '../../../appointment_config/domain/usecases/sync_config_usecase.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../data/models/appointment_model.dart';
import '../../domain/entities/cancellation.dart';
import '../../domain/entities/qrcode.dart';
import '../../domain/usecases/create_new_appointment_usecase.dart';
import '../../domain/usecases/update_appointment_usecase.dart';
import '../widgets/book_appointment_widget/book_appointment_form.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => BookAppointmentPageState();
}

class BookAppointmentPageState extends State<BookAppointmentPage> {
  static const _textFields = [field_description];

  static const _dropdownFields = [
    field_appointmentDateTime,
    field_appointmentType,
  ];

  late final Map<String, TextEditingController> textControllers;
  late final Map<String, ValueNotifier<String?>> dropdownControllers;
  late final FormCubit formCubit;
  bool _configLoaded = false;
  AppointmentModel? _existingAppointment;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_existingAppointment == null) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      _existingAppointment = extra?['appointment'] as AppointmentModel?;
      if (_existingAppointment != null) {
        _populateFormWithExistingAppointment();
      }
    }
  }

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

  void _populateFormWithExistingAppointment() {
    if (_existingAppointment == null) return;

    // Populate description
    textControllers[field_description.field_key]?.text =
        _existingAppointment!.description;

    // Populate appointment type
    dropdownControllers[field_appointmentType.field_key]?.value =
        _existingAppointment!.appointmentType;

    // Populate date time (format as expected by the form)
    final startTime = formatUtcToLocal(
      utcTime: _existingAppointment!.scheduledStartAt.toString(),
      style: DateTimeFormatStyle.timeOnly,
    );
    final endTime = formatUtcToLocal(
      utcTime: _existingAppointment!.scheduledEndAt.toString(),
      style: DateTimeFormatStyle.timeOnly,
    );
    final date = formatUtcToLocal(
      utcTime: _existingAppointment!.scheduledStartAt.toString(),
      style: DateTimeFormatStyle.dateOnly,
    );

    final dateTimeString = '$date $startTime - $endTime';
    dropdownControllers[field_appointmentDateTime.field_key]?.value =
        dateTimeString;
  }

  String? get category {
    if (_existingAppointment != null) {
      return _existingAppointment!.appointmentCategory;
    }
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    return extra?['category'] as String?;
  }

  bool get isRescheduling => _existingAppointment != null;

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

  void handleSubmit(BuildContext context) {
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
      // optionalFields: _optionalFields.map((field) => field.field_key).toList(),
    );

    if (!isValid) return;

    if (isRescheduling) {
      _performRescheduling(context);
    } else {
      _performBooking(context);
    }
  }

  void _performBooking(BuildContext context) {
    final category = this.category;
    final currentUserId = SharedPrefs().getString('currentUserId')!;
    final appointmentType = _getDropdownValue(field_appointmentType);
    final dateTimeSelected = _getDropdownValue(field_appointmentDateTime);
    final description = _getTextValue(field_description);

    final parsed = parseDateTimeRange(dateTimeSelected);

    final _new_appointments = AppointmentModel(
      studentId: currentUserId,
      scheduledStartAt: parsed['start']!,
      scheduledEndAt: parsed['end']!,
      appointmentCategory: category!,
      appointmentType: appointmentType,
      description: description,
      status: 'pending',
      checkInStatus: 'not-check-in',
      qrCode: const QRCode(),
      cancellation: const Cancellation(),
      createdBy: currentUserId,
      appointmentId: '',
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    context.read<ButtonCubit>().execute(
          usecase: sl<CreateNewAppointmentUsecase>(),
          params: _new_appointments,
        );
  }

  void _performRescheduling(BuildContext context) {
    if (_existingAppointment == null) return;

    final appointmentType = _getDropdownValue(field_appointmentType);
    final dateTimeSelected = _getDropdownValue(field_appointmentDateTime);
    final description = _getTextValue(field_description);

    final parsed = parseDateTimeRange(dateTimeSelected);

    final updatedAppointment = AppointmentModel(
      studentId: _existingAppointment!.studentId,
      scheduledStartAt: parsed['start']!,
      scheduledEndAt: parsed['end']!,
      appointmentCategory: _existingAppointment!.appointmentCategory,
      appointmentType: appointmentType,
      description: description,
      status: 'pending',
      checkInStatus: _existingAppointment!.checkInStatus,
      qrCode: _existingAppointment!.qrCode,
      cancellation: _existingAppointment!.cancellation,
      createdBy: _existingAppointment!.createdBy,
      appointmentId: _existingAppointment!.appointmentId,
      updatedAt: DateTime.now(),
      createdAt: _existingAppointment!.createdAt,
    );

    context.read<ButtonCubit>().execute(
          usecase: sl<UpdateAppointmentUsecase>(),
          params: updatedAppointment,
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ButtonCubit()),
        BlocProvider(create: (context) => AppointmentConfigCubit()),
      ],
      child: Builder(
        builder: (context) {
          if (!_configLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AppointmentConfigCubit>().loadAppointmentConfig(
                    usecase: sl<SyncConfigUsacase>(),
                  );
              _configLoaded = true;
            });
          }

          return Scaffold(
            appBar: CustomAppBar(
              leadingText: 'Back',
              title: isRescheduling
                  ? 'Reschedule Appointment'
                  : 'Book Appointment',
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
          );
        },
      ),
    );
  }

  Future<void> _handleButtonState(
    BuildContext context,
    ButtonState state,
  ) async {
    String message;
    bool isSuccess = false;

    if (state is ButtonSuccessState) {
      isSuccess = true;
      message = isRescheduling
          ? 'Appointment rescheduled successfully'
          : 'Appointment created successfully';

      AppToast.show(message: message, type: ToastType.success);
    } else if (state is ButtonFailureState) {
      message = isRescheduling
          ? 'Could not reschedule the appointment. Please check your internet or try later.'
          : 'Could not book the appointment. Please check your internet or try later.';

      AppToast.show(message: message, type: ToastType.error);
    } else {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1500));

    if (isSuccess && context.mounted) {
      context.go(Routes.home_path);
    }
  }
}
