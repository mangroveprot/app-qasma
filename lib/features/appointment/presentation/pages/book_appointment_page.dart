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
import '../../../appointment_config/domain/usecases/sync_config_usecase.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../data/models/appointment_model.dart';
import '../../domain/entities/cancellation.dart';
import '../../domain/entities/qrcode.dart';
import '../../domain/entities/reschedule.dart';
import '../../domain/usecases/create_new_appointment_usecase.dart';
import '../../domain/usecases/update_appointment_usecase.dart';
import '../widgets/book_appointment_widget/book_appointment_form.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => BookAppointmentPageState();
}

class BookAppointmentPageState extends State<BookAppointmentPage> {
  static const _textFields = [
    field_description,
    field_remarks,
  ];

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

    textControllers[field_description.field_key]?.text =
        _existingAppointment!.description;

    textControllers[field_remarks.field_key]?.text =
        _existingAppointment!.reschedule.remarks.toString();

    dropdownControllers[field_appointmentType.field_key]?.value =
        _existingAppointment!.appointmentType;

    final startAt = _existingAppointment!.scheduledStartAt;
    final endAt = _existingAppointment!.scheduledEndAt;

    final String startDate =
        "${startAt.year.toString().padLeft(4, '0')}-${startAt.month.toString().padLeft(2, '0')}-${startAt.day.toString().padLeft(2, '0')}";
    final String startTime =
        "${startAt.hour % 12 == 0 ? 12 : startAt.hour % 12}:${startAt.minute.toString().padLeft(2, '0')} ${startAt.hour >= 12 ? 'PM' : 'AM'}";

    final String endTime =
        "${endAt.hour % 12 == 0 ? 12 : endAt.hour % 12}:${endAt.minute.toString().padLeft(2, '0')} ${endAt.hour >= 12 ? 'PM' : 'AM'}";

    final String dateTimeString = '$startDate | $startTime - $endTime';

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
    FocusScope.of(context).unfocus();
    final isValid = formCubit.validateAll(
      _buildValidationFields(),
      optionalFields: isRescheduling ? <String>[] : [field_remarks.field_key],
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
      feedbackSubmitted: false,
      qrCode: const QRCode(),
      cancellation: const Cancellation(),
      reschedule: const Reschedule(),
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
    final remarks = _getTextValue(field_remarks);

    final parsed = parseDateTimeRange(dateTimeSelected);

    final isSameTimeSlot =
        _existingAppointment!.scheduledStartAt == parsed['start'] &&
            _existingAppointment!.scheduledEndAt == parsed['end'];

    final Map<String, dynamic> updateFields = {
      'appointmentId': _existingAppointment!.appointmentId,
      'appointmentType': appointmentType,
      'description': description,
    };

    if (!isSameTimeSlot) {
      updateFields['scheduledStartAt'] = parsed['start']!.toIso8601String();
      updateFields['scheduledEndAt'] = parsed['end']!.toIso8601String();
      updateFields['reschedule'] = {
        'rescheduledBy': SharedPrefs().getString('currentUserId') ?? '',
        'remarks': remarks,
        'rescheduledAt': DateTime.now().toIso8601String(),
        'previousStart':
            _existingAppointment!.scheduledStartAt.toIso8601String(),
        'previousEnd': _existingAppointment!.scheduledEndAt.toIso8601String(),
      };
    } else if (remarks.isNotEmpty) {
      updateFields['reschedule'] = {
        'rescheduledBy': _existingAppointment!.reschedule.rescheduledBy ??
            SharedPrefs().getString('currentUserId') ??
            '',
        'remarks': remarks,
        'rescheduledAt':
            (_existingAppointment!.reschedule.rescheduledAt ?? DateTime.now())
                .toIso8601String(),
        'previousStart': (_existingAppointment!.reschedule.previousStart ??
                _existingAppointment!.scheduledStartAt)
            .toIso8601String(),
        'previousEnd': (_existingAppointment!.reschedule.previousEnd ??
                _existingAppointment!.scheduledEndAt)
            .toIso8601String(),
      };
    }

    final dynamicParam = DynamicParam(fields: updateFields);

    context.read<ButtonCubit>().execute(
          usecase: sl<UpdateAppointmentUsecase>(),
          params: dynamicParam,
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
                    usecase: sl<SyncConfigUsecase>(),
                  );
              _configLoaded = true;
            });
          }

          return Scaffold(
            appBar: CustomAppBar(
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
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final onSuccess = extra?['onSuccess'] as Function()?;

      if (onSuccess != null) {
        try {
          await onSuccess();
        } catch (e) {
          debugPrint('Error calling success callback: $e');
        }
      }
      context.pop();
    }
  }
}
