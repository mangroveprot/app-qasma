import '../../domain/entities/reschedule.dart';

class RescheduleModel extends Reschedule {
  const RescheduleModel({
    super.rescheduledBy,
    super.remarks,
    super.rescheduledAt,
    super.previousStart,
    super.previousEnd,
  });

  static String? _getValue(
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

    return null;
  }

  static DateTime? _getDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1]?.toString() ?? map[key2]?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    return null;
  }

  factory RescheduleModel.fromMap(Map<String, dynamic> map) {
    return RescheduleModel(
      rescheduledBy: _getValue(map, 'rescheduledBy', 'rescheduled_by'),
      remarks: _getValue(map, 'remarks'),
      rescheduledAt: _getDateTime(map, 'rescheduledAt', 'rescheduled_at'),
      previousStart: _getDateTime(map, 'previousStart', 'previous_start'),
      previousEnd: _getDateTime(map, 'previousEnd', 'previous_end'),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'rescheduledBy': rescheduledBy,
      'remarks': remarks,
      'rescheduledAt': rescheduledAt?.toIso8601String(),
      'previousStart': previousStart?.toIso8601String(),
      'previousEnd': previousEnd?.toIso8601String(),
    };
  }

  Reschedule toEntity() {
    return Reschedule(
      rescheduledBy: rescheduledBy,
      remarks: remarks,
      rescheduledAt: rescheduledAt,
      previousStart: previousStart,
      previousEnd: previousEnd,
    );
  }

  factory RescheduleModel.fromEntity(Reschedule entity) {
    return RescheduleModel(
      rescheduledBy: entity.rescheduledBy,
      remarks: entity.remarks,
      rescheduledAt: entity.rescheduledAt,
      previousStart: entity.previousStart,
      previousEnd: entity.previousEnd,
    );
  }

  @override
  String toString() {
    return 'RescheduleModel(rescheduledBy: $rescheduledBy, remarks: $remarks, rescheduledAt: $rescheduledAt, previousStart: $previousStart, previousEnd: $previousEnd)';
  }
}
