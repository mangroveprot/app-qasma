import '../../domain/entites/reminder.dart';

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.message,
  });

  // to db (sqlite)
  Map<String, dynamic> toDb() {
    return {
      'message': message,
    };
  }

  // from localdb (sqlite)
  factory ReminderModel.fromDb(Map<String, dynamic> map) {
    return ReminderModel(
      message: map['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
    };
  }

  // From API (JSON format)
  factory ReminderModel.fromMap(Map<String, dynamic> json) {
    return ReminderModel(
      message: json['message']?.toString() ?? '',
    );
  }

  // Convert to entity
  Reminder toEntity() {
    return Reminder(
      message: message,
    );
  }

  // Create from entity
  factory ReminderModel.fromEntity(Reminder entity) {
    return ReminderModel(
      message: entity.message,
    );
  }
}
