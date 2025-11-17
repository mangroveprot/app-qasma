import 'package:equatable/equatable.dart';
import 'category.dart';
import 'time_slot.dart';
import 'reminder.dart';

class AppointmentConfig extends Equatable {
  final int? sessionDuration;
  final int? bufferTime;
  final int? bookingLeadTime;
  final int? slotDaysRange;
  final List<Reminder>? reminders;
  final Map<String, List<TimeSlot>>? availableDayTime;
  final Map<String, Category>? categoryAndType;
  final DateTime? deletedAt;
  final String? deletedBy;
  final String? createdBy;
  final String? updatedBy;
  final String? configId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppointmentConfig({
    this.sessionDuration,
    this.bufferTime,
    this.bookingLeadTime,
    this.slotDaysRange,
    this.reminders,
    this.availableDayTime,
    this.categoryAndType,
    this.deletedAt,
    this.deletedBy,
    this.createdBy,
    this.updatedBy,
    this.configId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        sessionDuration,
        bufferTime,
        bookingLeadTime,
        slotDaysRange,
        reminders,
        availableDayTime,
        categoryAndType,
        deletedAt,
        deletedBy,
        createdBy,
        updatedBy,
        configId,
        createdAt,
        updatedAt,
      ];

  AppointmentConfig copyWith({
    int? sessionDuration,
    int? bufferTime,
    int? bookingLeadTime,
    int? slotDaysRange,
    List<Reminder>? reminders,
    Map<String, List<TimeSlot>>? availableDayTime,
    Map<String, Category>? categoryAndType,
    DateTime? deletedAt,
    String? deletedBy,
    String? createdBy,
    String? updatedBy,
    String? configId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentConfig(
      sessionDuration: sessionDuration ?? this.sessionDuration,
      bufferTime: bufferTime ?? this.bufferTime,
      bookingLeadTime: bookingLeadTime ?? this.bookingLeadTime,
      slotDaysRange: slotDaysRange ?? this.slotDaysRange,
      reminders: reminders ?? this.reminders,
      availableDayTime: availableDayTime ?? this.availableDayTime,
      categoryAndType: categoryAndType ?? this.categoryAndType,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      configId: configId ?? this.configId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Validation methods
  bool get isValid {
    return configId != null && configId!.isNotEmpty;
  }

  bool get hasTimeSlots {
    return availableDayTime != null && availableDayTime!.isNotEmpty;
  }

  bool get hasReminders {
    return reminders != null && reminders!.isNotEmpty;
  }

  bool get hasCategories {
    return categoryAndType != null && categoryAndType!.isNotEmpty;
  }
}
