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

  factory TimeSlotModel.fromScheduleKey(String key, String day) {
    final List<String> parts = key.split('-');
    final String startTime = parts[0]; // e.g., "10:30AM"
    final String endTime = parts[1]; // e.g., "11:00AM"

    // Convert to 24-hour format
    final String start24 = _convertTo24Hour(startTime);
    final String end24 = _convertTo24Hour(endTime);

    return TimeSlotModel(
      start: start24,
      end: end24,
    );
  }

  static String _convertTo24Hour(String time12) {
    if (!time12.contains('AM') && !time12.contains('PM')) {
      final parts = time12.split(':');
      if (parts.length >= 2) {
        return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      }
      return time12;
    }

    final String cleanTime =
        time12.replaceAll('AM', '').replaceAll('PM', '').trim();
    final List<String> parts = cleanTime.split(':');
    int hour = int.parse(parts[0]);
    final String minute = parts.length > 1 ? parts[1] : '00';
    final bool isPM = time12.contains('PM');

    if (hour == 12) {
      hour = isPM ? 12 : 0;
    } else if (isPM) {
      hour += 12;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'TimeSlotModel(start: $start, end: $end)';
  }
}
