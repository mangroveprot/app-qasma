import '../../domain/entites/time_slot.dart';

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.start,
    required super.end,
  });

  // to db (sqflite)
  Map<String, dynamic> toDb() {
    return {
      'start': start,
      'end': end,
    };
  }

  // from localdb (sqflite)
  factory TimeSlotModel.fromDb(Map<String, dynamic> map) {
    return TimeSlotModel(
      start: map['start']?.toString() ?? '',
      end: map['end']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
    };
  }

  // From API (JSON format)
  factory TimeSlotModel.fromMap(Map<String, dynamic> json) {
    return TimeSlotModel(
      start: json['start']?.toString() ?? '',
      end: json['end']?.toString() ?? '',
    );
  }

  // Convert to entity
  TimeSlot toEntity() {
    return TimeSlot(
      start: start,
      end: end,
    );
  }

  // Create from entity
  factory TimeSlotModel.fromEntity(TimeSlot entity) {
    return TimeSlotModel(
      start: entity.start,
      end: entity.end,
    );
  }
}
