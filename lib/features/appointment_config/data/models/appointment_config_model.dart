import 'dart:convert';
import '../../../../common/utils/model_utils.dart';
import '../../domain/entites/appointmet_config.dart';
import '../../domain/entites/category_type.dart';
import '../../domain/entites/time_slot.dart';
import '../../domain/entites/reminder.dart';
import 'category_model.dart';
import 'time_slot_model.dart';
import 'reminder_model.dart';

class AppointmentConfigModel extends AppointmentConfig {
  const AppointmentConfigModel({
    super.sessionDuration,
    super.bufferTime,
    super.bookingLeadTime,
    super.slotDaysRange,
    super.reminders,
    super.availableDayTime,
    super.categoryAndType,
    super.deletedAt,
    super.deletedBy,
    super.createdBy,
    super.updatedBy,
    super.configId,
    super.createdAt,
    super.updatedAt,
  });

  // helpers for value safety
  static List<Reminder>? _parseReminders(dynamic reminders) {
    if (reminders is List) {
      return reminders
          .whereType<String>()
          .map((message) => ReminderModel(message: message))
          .toList();
    }
    return null;
  }

  static Map<String, List<TimeSlot>>? _parseAvailableDayTime(
      dynamic availableDayTime) {
    if (availableDayTime is! Map<String, dynamic>) {
      return null;
    }

    final Map<String, List<TimeSlot>> result = {};

    availableDayTime.forEach((day, timeSlots) {
      if (timeSlots is List) {
        result[day] = timeSlots
            .whereType<Map<String, dynamic>>()
            .map((slot) => TimeSlotModel.fromMap(slot))
            .toList();
      }
    });

    return result.isEmpty ? null : result;
  }

  static Map<String, Category>? _parseCategoryAndType(dynamic categoryAndType) {
    if (categoryAndType is! Map<String, dynamic>) {
      return null;
    }

    final Map<String, Category> result = {};

    categoryAndType.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        final category = CategoryModel.fromMap(value);
        result[key] = category;
      }
    });

    return result.isEmpty ? null : result;
  }

  // to db (sqlite)
  Map<String, dynamic> toDb() {
    return {
      'sessionDuration': sessionDuration,
      'bufferTime': bufferTime,
      'bookingLeadTime': bookingLeadTime,
      'slotDaysRange': slotDaysRange,
      'reminders': reminders != null
          ? jsonEncode(reminders!.map((r) => r.message).toList())
          : null,
      'availableDayTime': availableDayTime != null
          ? jsonEncode(availableDayTime!.map(
              (key, value) => MapEntry(
                  key,
                  value
                      .map((slot) => TimeSlotModel.fromEntity(slot).toMap())
                      .toList()),
            ))
          : null,
      'categoryAndType': categoryAndType != null
          ? jsonEncode(categoryAndType!.map(
              (key, value) =>
                  MapEntry(key, CategoryModel.fromEntity(value).toMap()),
            ))
          : null,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'configId': configId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory AppointmentConfigModel.fromDb(Map<String, dynamic> map) {
    return AppointmentConfigModel(
      sessionDuration: map['sessionDuration'] as int?,
      bufferTime: map['bufferTime'] as int?,
      bookingLeadTime: map['bookingLeadTime'] as int?,
      slotDaysRange: map['slotDaysRange'] as int?,
      reminders: _parseReminders(
        map['reminders'] != null ? jsonDecode(map['reminders']) : null,
      ),
      availableDayTime: _parseAvailableDayTime(
        map['availableDayTime'] != null
            ? jsonDecode(map['availableDayTime'])
            : null,
      ),
      categoryAndType: _parseCategoryAndType(
        map['categoryAndType'] != null
            ? jsonDecode(map['categoryAndType'])
            : null,
      ),
      deletedAt:
          map['deletedAt'] != null ? DateTime.tryParse(map['deletedAt']) : null,
      deletedBy: map['deletedBy'] as String?,
      createdBy: map['createdBy'] as String?,
      updatedBy: map['updatedBy'] as String?,
      configId: map['configId'] as String?,
      createdAt:
          map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionDuration': sessionDuration,
      'bufferTime': bufferTime,
      'bookingLeadTime': bookingLeadTime,
      'slotDaysRange': slotDaysRange,
      'reminders': reminders?.map((r) => r.message).toList(),
      'availableDayTime': availableDayTime?.map(
        (key, value) => MapEntry(
            key,
            value
                .map((slot) => TimeSlotModel.fromEntity(slot).toMap())
                .toList()),
      ),
      'categoryAndType': categoryAndType?.map(
        (key, value) => MapEntry(key, CategoryModel.fromEntity(value).toMap()),
      ),
      'configId': configId,
    };
  }

  // From API (JSON format) - handles both camelCase and snake_case
  factory AppointmentConfigModel.fromJson(Map<String, dynamic> json) {
    return AppointmentConfigModel(
      sessionDuration: ModelUtils.getNullableInt(
          json, 'sessionDuration', 'session_duration'),
      bufferTime: ModelUtils.getNullableInt(json, 'bufferTime', 'buffer_time'),
      bookingLeadTime: ModelUtils.getNullableInt(
          json, 'bookingLeadTime', 'booking_lead_time'),
      slotDaysRange:
          ModelUtils.getNullableInt(json, 'slotDaysRange', 'slot_days_range'),
      reminders: _parseReminders(json['reminders']),
      availableDayTime: _parseAvailableDayTime(
          json['availableDayTime'] ?? json['available_day_time']),
      categoryAndType: _parseCategoryAndType(
          json['categoryAndType'] ?? json['category_and_type']),
      deletedAt:
          ModelUtils.getNullableDateTime(json, 'deletedAt', 'deleted_at'),
      deletedBy: ModelUtils.getNullableString(json, 'deletedBy', 'deleted_by'),
      createdBy: ModelUtils.getNullableString(json, 'createdBy', 'created_by'),
      updatedBy: ModelUtils.getNullableString(json, 'updatedBy', 'updated_by'),
      configId: ModelUtils.getNullableString(json, 'configId', 'config_id'),
      createdAt:
          ModelUtils.getNullableDateTime(json, 'createdAt', 'created_at'),
      updatedAt:
          ModelUtils.getNullableDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  // Convert to entity
  AppointmentConfig toEntity() {
    return AppointmentConfig(
      sessionDuration: sessionDuration,
      bufferTime: bufferTime,
      bookingLeadTime: bookingLeadTime,
      slotDaysRange: slotDaysRange,
      reminders: reminders,
      availableDayTime: availableDayTime,
      categoryAndType: categoryAndType,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
      createdBy: createdBy,
      updatedBy: updatedBy,
      configId: configId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Create from entity
  factory AppointmentConfigModel.fromEntity(AppointmentConfig entity) {
    return AppointmentConfigModel(
      sessionDuration: entity.sessionDuration,
      bufferTime: entity.bufferTime,
      bookingLeadTime: entity.bookingLeadTime,
      slotDaysRange: entity.slotDaysRange,
      reminders:
          entity.reminders?.map((r) => ReminderModel.fromEntity(r)).toList(),
      availableDayTime: entity.availableDayTime?.map(
        (key, value) => MapEntry(
            key, value.map((slot) => TimeSlotModel.fromEntity(slot)).toList()),
      ),
      categoryAndType: entity.categoryAndType?.map(
        (key, value) => MapEntry(key, CategoryModel.fromEntity(value)),
      ),
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      configId: entity.configId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
