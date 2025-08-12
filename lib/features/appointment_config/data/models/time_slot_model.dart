import '../../domain/entites/time_slot.dart';

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.start,
    required super.end,
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
      'start': start,
      'end': end,
    };
  }

  factory TimeSlotModel.fromDb(Map<String, dynamic> map) {
    return TimeSlotModel(
      start: _getString(map, 'start'),
      end: _getString(map, 'end'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
    };
  }

  factory TimeSlotModel.fromMap(Map<String, dynamic> json) {
    return TimeSlotModel(
      start: _getString(json, 'start'),
      end: _getString(json, 'end'),
    );
  }

  TimeSlot toEntity() {
    return TimeSlot(
      start: start,
      end: end,
    );
  }

  factory TimeSlotModel.fromEntity(TimeSlot entity) {
    return TimeSlotModel(
      start: entity.start,
      end: entity.end,
    );
  }

  @override
  String toString() {
    return 'TimeSlotModel(start: $start, end: $end)';
  }
}
