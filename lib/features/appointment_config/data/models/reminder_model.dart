import '../../domain/entites/reminder.dart';

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.message,
  });

  static String _getString(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    if (map.containsKey(key1)) {
      final value = map[key1];
      if (value != null) return value.toString();
    }

    if (key2 != null && map.containsKey(key2)) {
      final value = map[key2];
      if (value != null) return value.toString();
    }

    return '';
  }

  Map<String, dynamic> toDb() {
    return {
      'message': message,
    };
  }

  factory ReminderModel.fromDb(Map<String, dynamic> map) {
    return ReminderModel(
      message: _getString(map, 'message'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> json) {
    return ReminderModel(
      message: _getString(json, 'message'),
    );
  }

  Reminder toEntity() {
    return Reminder(
      message: message,
    );
  }

  factory ReminderModel.fromEntity(Reminder entity) {
    return ReminderModel(
      message: entity.message,
    );
  }

  @override
  String toString() {
    return 'ReminderModel(message: $message)';
  }
}
