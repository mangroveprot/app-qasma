import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/manager/appointment_config_manager.dart';
import '../../../../common/manager/user_manager.dart';
import '../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../appointment_config/data/models/time_slot_model.dart';
import '../../../appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../../users/presentation/bloc/user_cubit.dart';
import '../config/schedule_config.dart';

class ScheduleController {
  late final ButtonCubit _buttonCubit;
  late final UserCubit _userCubit;
  late final AppointmentConfigCubit _appointmentConfigCubit;

  late final UserManager _userManager;
  late final AppointmentConfigManager _appointmentConfigManager;

  final ValueNotifier<Map<String, List<TimeSlotModel>>> _scheduleNotifier =
      ValueNotifier({});
  final ValueNotifier<bool> _hasChangesNotifier = ValueNotifier(false);

  Map<String, List<TimeSlotModel>> _originalSchedule = {};

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  String get currentUserId => SharedPrefs().getString('currentUserId') ?? '';

  ValueNotifier<Map<String, List<TimeSlotModel>>> get scheduleNotifier =>
      _scheduleNotifier;
  ValueNotifier<bool> get hasChangesNotifier => _hasChangesNotifier;
  Map<String, List<TimeSlotModel>> get currentSchedule =>
      _scheduleNotifier.value;

  List<BlocProvider> get blocProviders => [
        BlocProvider<UserCubit>(
          create: (context) => _userCubit,
        ),
        BlocProvider<ButtonCubit>(
          create: (context) => _buttonCubit,
        ),
        BlocProvider<AppointmentConfigCubit>(
          create: (context) => _appointmentConfigCubit,
        ),
      ];

  void initialize({
    Function(String route, {Object? extra})? onNavigate,
  }) {
    _initializeManagers();
    _initializeCubits();
    _loadInitialData();
    _isInitialized = true;
  }

  void _initializeManagers() {
    _userManager = UserManager();
    _appointmentConfigManager = AppointmentConfigManager();
  }

  void _initializeCubits() {
    _userCubit = UserCubit();
    _buttonCubit = ButtonCubit();
    _appointmentConfigCubit = AppointmentConfigCubit();
  }

  ButtonCubit get buttonCubit => _buttonCubit;
  AppointmentConfigCubit get appointmentConfigCubit => _appointmentConfigCubit;
  UserCubit get userCubit => _userCubit;

  void _loadInitialData() {
    _getUserProfile(currentUserId);
    _getConfig();
  }

  void _getUserProfile(String idNumber) {
    _userManager.getUserProfile(_userCubit, idNumber);
  }

  void _getConfig() {
    _appointmentConfigManager
        .loadAllAppointmentsConfig(_appointmentConfigCubit);
  }

  Future<void> refreshUser() async {
    await _userManager.refreshUser(_userCubit);
  }

  void initializeSchedule(Map<String, List<TimeSlotModel>> schedule) {
    _scheduleNotifier.value = schedule;
    _originalSchedule = _deepCopySchedule(schedule);
    _hasChangesNotifier.value = false;
  }

  void addTimeSlot(String day) {
    final updatedSchedule =
        Map<String, List<TimeSlotModel>>.from(_scheduleNotifier.value);
    updatedSchedule[day] = List.from(updatedSchedule[day]!)
      ..add(const TimeSlotModel(start: '08:00', end: '09:00'));

    _scheduleNotifier.value = updatedSchedule;
    _updateHasChanges();
  }

  void removeTimeSlot(String day, int index) {
    final updatedSchedule =
        Map<String, List<TimeSlotModel>>.from(_scheduleNotifier.value);
    updatedSchedule[day] = List.from(updatedSchedule[day]!)..removeAt(index);

    _scheduleNotifier.value = updatedSchedule;
    _updateHasChanges();
  }

  void updateTimeSlot(String day, int index, String field, String value) {
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

  void cancelChanges() {
    _scheduleNotifier.value = _deepCopySchedule(_originalSchedule);
    _hasChangesNotifier.value = false;
  }

  void markAsSaved() {
    _originalSchedule = _deepCopySchedule(_scheduleNotifier.value);
    _hasChangesNotifier.value = false;
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

    for (final day in ScheduleConfig.weekDays) {
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

  void dispose() {
    _scheduleNotifier.dispose();
    _hasChangesNotifier.dispose();
  }
}
