import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/presentation/widgets/basic_save_action_buttons.dart';
import '../../../../common/utils/tooltips_items.dart';
import '../../../../infrastructure/routes/app_route_extractor.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../common/widgets/custom_app_bar.dart';
import '../../../../common/widgets/toast/app_toast.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../appointment_config/data/models/appointment_config_model.dart';
import '../../../appointment_config/data/models/time_slot_model.dart';
import '../../../appointment_config/domain/usecases/update_config_uscase.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/data/models/other_info_model.dart';
import '../../../users/data/models/params/dynamic_param.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/domain/usecases/update_user_usecase.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../config/schedule_config.dart';
import '../controllers/schedule_controller.dart';
import '../utils/schedule_utils.dart';
import '../widgets/schedule_widget/day_schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final ScheduleController controller;
  final weekdays = ScheduleConfig.weekDays;
  final ValueNotifier<Map<String, List<TimeSlotModel>>> _scheduleNotifier =
      ValueNotifier({});
  final ValueNotifier<bool> _hasChangesNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(true);

  Map<String, List<TimeSlotModel>> _originalSchedule = {};
  Map<String, dynamic>? _routeData;
  bool userDataLoaded = false;
  bool configDataLoaded = false;

  @override
  void initState() {
    super.initState();
    controller = ScheduleController();

    // Start the loading delay immediately
    _initializeWithDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _extractRouteData();

    if (!controller.isInitialized) {
      controller.initialize();
    }
  }

  Future<void> _initializeWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _isLoadingNotifier.value = false;
    }
  }

  void _extractRouteData() {
    if (_routeData != null) return;

    final rawExtra = GoRouterState.of(context).extra;

    _routeData = rawExtra as Map<String, dynamic>?;

    if (_routeData == null) {
      _routeData = AppRouteExtractor.extractRaw<Map<String, dynamic>>(rawExtra);
    }
  }

  bool get isConfig => _routeData?['isConfig'] as bool? ?? false;

  void _initializeUserSchedule() {
    if (!userDataLoaded) return;
    final initialSchedule = <String, List<TimeSlotModel>>{};
    for (final day in weekdays) {
      initialSchedule[day] = <TimeSlotModel>[];
    }

    final UserModel currentUser = controller.userCubit
        .filterUsers(
          predicate: (user) => user.idNumber == controller.currentUserId,
        )
        .first;

    final slots = ScheduleUtils.convertAPIDataToSchedule(
      currentUser.other_info as OtherInfoModel,
    );

    _scheduleNotifier.value = slots;
    _originalSchedule = _deepCopySchedule(slots);
  }

  void _initializeAppointmentConfigSchedule() {
    if (!configDataLoaded) return;
    final initialSchedule = <String, List<TimeSlotModel>>{};
    for (final day in weekdays) {
      initialSchedule[day] = <TimeSlotModel>[];
    }

    final AppointmentConfigModel? config =
        controller.appointmentConfigCubit.currentConfig;

    final slots = ScheduleUtils.convertAPIDataToSchedule(
      config!.availableDayTime,
      isConfig: isConfig,
    );

    _scheduleNotifier.value = slots;
    _originalSchedule = _deepCopySchedule(slots);
  }

  Map<String, List<TimeSlotModel>> _deepCopySchedule(
      Map<String, List<TimeSlotModel>> source) {
    return source.map(
      (day, slots) => MapEntry(
        day,
        slots
            .map((slot) => TimeSlotModel(start: slot.start, end: slot.end))
            .toList(),
      ),
    );
  }

  void _updateHasChanges() {
    final current = _scheduleNotifier.value;
    bool hasChanges = false;

    for (final day in weekdays) {
      final currentSlots = current[day] ?? [];
      final originalSlots = _originalSchedule[day] ?? [];

      if (currentSlots.length != originalSlots.length) {
        hasChanges = true;
        break;
      }

      for (int i = 0; i < currentSlots.length; i++) {
        if (currentSlots[i] != originalSlots[i]) {
          hasChanges = true;
          break;
        }
      }

      if (hasChanges) break;
    }

    _hasChangesNotifier.value = hasChanges;
  }

  void _addTimeSlot(String day) {
    final updatedSchedule =
        Map<String, List<TimeSlotModel>>.from(_scheduleNotifier.value);
    updatedSchedule[day] = List.from(updatedSchedule[day]!)
      ..add(const TimeSlotModel(start: '08:00', end: '09:00'));

    _scheduleNotifier.value = updatedSchedule;
    _updateHasChanges();
  }

  void _removeTimeSlot(String day, int index) {
    final updatedSchedule =
        Map<String, List<TimeSlotModel>>.from(_scheduleNotifier.value);
    updatedSchedule[day] = List.from(updatedSchedule[day]!)..removeAt(index);

    _scheduleNotifier.value = updatedSchedule;
    _updateHasChanges();
  }

  void _updateTimeSlot(String day, int index, String field, String value) {
    final updatedSchedule =
        Map<String, List<TimeSlotModel>>.from(_scheduleNotifier.value);
    final slots = List<TimeSlotModel>.from(updatedSchedule[day]!);
    final currentSlot = slots[index];

    slots[index] = TimeSlotModel(
      start: field == 'start' ? value : currentSlot.start,
      end: field == 'end' ? value : currentSlot.end,
    );

    updatedSchedule[day] = slots;
    _scheduleNotifier.value = updatedSchedule;
    _updateHasChanges();
  }

  void _saveChanges() {
    final saveData = _scheduleNotifier.value.map((day, slots) =>
        MapEntry(day, slots.map((slot) => slot.toDb()).toList()));

    final convertedSaveData =
        ScheduleUtils.createSaveData(saveData, isConfig: isConfig);

    if (!isConfig)
      _performUserUpdate(convertedSaveData);
    else
      _performConfigUpdate(convertedSaveData);
  }

  void _performConfigUpdate(Map<String, dynamic> saveData) {
    final String? configId =
        controller.appointmentConfigCubit.currentConfig?.configId;
    if (configId != null) {
      final Map<String, dynamic> params = {'configId': configId, ...saveData};
      final param = DynamicParam(fields: params);
      controller.buttonCubit.execute(
        buttonId: 'save_schedule',
        usecase: sl<UpdateConfigUsecase>(),
        params: param,
      );
    } else {
      AppToast.show(
        message: ' state.errorMessages.first',
        type: ToastType.error,
      );
    }
  }

  void _performUserUpdate(Map<String, dynamic> saveData) {
    final Map<String, dynamic> data = {
      'idNumber': controller.currentUserId,
      ...saveData
    };
    final params = DynamicParam(fields: data);
    controller.buttonCubit.execute(
      buttonId: 'save_schedule',
      usecase: sl<UpdateUserUsecase>(),
      params: params,
    );
  }

  void _cancelChanges() {
    _scheduleNotifier.value = _deepCopySchedule(_originalSchedule);
    _hasChangesNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: controller.blocProviders,
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserCubit, UserCubitState>(
            listener: _handleUserState,
          ),
          BlocListener<ButtonCubit, ButtonState>(
            listener: _handleButtonState,
          ),
          BlocListener<AppointmentConfigCubit, AppointmentConfigCubitState>(
            listener: _handleAppointmentConfigState,
          ),
        ],
        child: Scaffold(
          appBar: CustomAppBar(
            title: isConfig ? 'Available Schedule' : 'My Schedule',
            onBackPressed: _handleBack,
            tooltipMessage: isConfig
                ? ToolTips.available_schedule.tips
                : ToolTips.my_schedule.tips,
          ),
          body: ValueListenableBuilder<bool>(
            valueListenable: _isLoadingNotifier,
            builder: (context, isLoading, _) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<
                        Map<String, List<TimeSlotModel>>>(
                      valueListenable: _scheduleNotifier,
                      builder: (context, schedule, _) => ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: weekdays.length,
                        itemBuilder: (context, index) {
                          final day = weekdays[index];
                          final slots = schedule[day] ?? [];

                          return DayScheduleCard(
                            key: ValueKey(day),
                            day: day,
                            slots: slots,
                            onAddSlot: () => _addTimeSlot(day),
                            onRemoveSlot: (slotIndex) =>
                                _removeTimeSlot(day, slotIndex),
                            onUpdateSlot: (slotIndex, field, value) =>
                                _updateTimeSlot(day, slotIndex, field, value),
                            onSelectTime: ScheduleUtils.selectTime,
                          );
                        },
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _hasChangesNotifier,
                    builder: (context, hasChanges, _) => hasChanges
                        ? BasicSaveActionButtons(
                            onSave: _saveChanges,
                            onCancel: _cancelChanges,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleButtonState(BuildContext context, ButtonState state) {
    if (state is ButtonSuccessState && state.buttonId == 'save_schedule') {
      _originalSchedule = _deepCopySchedule(_scheduleNotifier.value);
      _hasChangesNotifier.value = false;

      AppToast.show(
        message: 'Schedule saved successfully!',
        type: ToastType.success,
      );
    } else if (state is ButtonFailureState &&
        state.buttonId == 'save_schedule') {
      AppToast.show(
        message: state.errorMessages.first,
        type: ToastType.error,
      );
    }
  }

  void _handleUserState(BuildContext context, UserCubitState state) {
    if (isConfig) return;
    if (state is UserLoadedState) {
      if (!userDataLoaded) {
        setState(() {
          userDataLoaded = true;
        });
        _initializeUserSchedule();
      }
    } else if (state is UserFailureState) {
      AppToast.show(message: 'Failed to load user data', type: ToastType.error);
      debugPrint('Failed to load user: ${state.errorMessages}');
    }
  }

  void _handleAppointmentConfigState(
    BuildContext context,
    AppointmentConfigCubitState state,
  ) {
    if (!isConfig) return;
    if (state is AppointmentConfigLoadedState) {
      if (!configDataLoaded) {
        setState(() {
          configDataLoaded = true;
        });
        _initializeAppointmentConfigSchedule();
      }
    } else if (state is AppointmentConfigFailureState) {
      AppToast.show(
          message: 'Failed to load appointment config data',
          type: ToastType.error);
      debugPrint('Failed to load appointment config: ${state.errorMessages}');
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

  @override
  void dispose() {
    _scheduleNotifier.dispose();
    _hasChangesNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }
}
