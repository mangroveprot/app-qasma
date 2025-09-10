import 'package:flutter/material.dart';
import '../../../appointment_config/data/models/time_slot_model.dart';
import '../../../users/data/models/other_info_model.dart';
import '../config/schedule_config.dart';

class ScheduleUtils {
  static Map<String, List<TimeSlotModel>> convertAPIDataToSchedule(
    dynamic data, {
    bool isConfig = false,
  }) {
    final Map<String, List<TimeSlotModel>> schedule = _createEmptySchedule();
    final sourceData = _extractSourceData(data, isConfig);

    if (sourceData != null) {
      _populateScheduleFromSource(schedule, sourceData);
    }

    return schedule;
  }

  static Map<String, dynamic> createSaveData(
    Map<String, List<Map<String, dynamic>>> saveData, {
    bool isConfig = false,
  }) {
    return isConfig
        ? {'available_day_time': saveData}
        : {
            'other_info': {
              'unavailableTimes': saveData,
            }
          };
  }

  static Future<String?> selectTime(
    BuildContext context,
    String initialTime,
  ) async {
    final initialTimeOfDay = _parseTimeString(initialTime);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTimeOfDay,
      initialEntryMode: TimePickerEntryMode.input,
    );

    return picked != null ? _formatTimeOfDay(picked) : null;
  }

  static Map<String, List<TimeSlotModel>> _createEmptySchedule() {
    final Map<String, List<TimeSlotModel>> schedule = {};
    for (final day in ScheduleConfig.weekDays) {
      schedule[day] = <TimeSlotModel>[];
    }
    return schedule;
  }

  static Map<String, dynamic>? _extractSourceData(dynamic data, bool isConfig) {
    if (isConfig) {
      if (data is Map<String, dynamic>) {
        return data;
      } else if (data is Map<String, List<TimeSlotModel>>) {
        return null;
      }
      return null;
    } else {
      if (data is OtherInfoModel) {
        return data.data['unavailableTimes'] as Map<String, dynamic>?;
      } else if (data is Map<String, dynamic>) {
        return data['unavailableTimes'] as Map<String, dynamic>? ?? data;
      }
      return null;
    }
  }

  static void _populateScheduleFromSource(
    Map<String, List<TimeSlotModel>> schedule,
    Map<String, dynamic> sourceData,
  ) {
    sourceData.forEach((dayName, timeSlots) {
      if (ScheduleConfig.weekDays.contains(dayName) && timeSlots is List) {
        final daySlots = <TimeSlotModel>[];

        for (var timeSlotData in timeSlots) {
          final timeSlot = _parseTimeSlot(timeSlotData);
          if (timeSlot != null) {
            daySlots.add(timeSlot);
          }
        }

        schedule[dayName] = daySlots;
      }
    });
  }

  static TimeSlotModel? _parseTimeSlot(dynamic timeSlotData) {
    if (timeSlotData is TimeSlotModel) {
      return timeSlotData;
    } else if (timeSlotData is Map<String, dynamic>) {
      try {
        return TimeSlotModel.fromMap(timeSlotData);
      } catch (e) {
        debugPrint('Error parsing time slot: $e');
        return null;
      }
    }
    return null;
  }

  static TimeOfDay _parseTimeString(String timeString) {
    final timeParts = timeString.split(':');
    final hour = int.tryParse(timeParts[0]) ?? 8;
    final minute = int.tryParse(timeParts.length > 1 ? timeParts[1] : '0') ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
