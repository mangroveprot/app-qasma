import '../helpers/helpers.dart';

class SlotManager {
  static List<String> formatSlotsForDropdown(Map<String, dynamic> slotsData) {
    final List<String> formattedSlots = [];

    if (slotsData.isEmpty) return formattedSlots;

    slotsData.forEach((date, timeSlots) {
      if (timeSlots is List) {
        final List<String> slots = List<String>.from(timeSlots);

        final groupedSlots = _groupConsecutiveSlots(slots);

        for (final group in groupedSlots) {
          formattedSlots.add('$date | $group');
        }
      }
    });

    formattedSlots.sort((a, b) {
      final dateTimeA = _extractDateTime(a);
      final dateTimeB = _extractDateTime(b);
      return dateTimeA.compareTo(dateTimeB);
    });

    return formattedSlots;
  }

  static List<String> _groupConsecutiveSlots(List<String> slots) {
    if (slots.isEmpty) return [];

    final List<String> groupedSlots = [];
    String? currentStart;
    String? currentEnd;

    for (int i = 0; i < slots.length; i++) {
      final slot = slots[i];
      final parts = slot.split(' - ');
      if (parts.length != 2) continue;

      final startTime = parts[0];
      final endTime = parts[1];

      if (currentStart == null) {
        currentStart = startTime;
        currentEnd = endTime;
      } else {
        if (_areConsecutiveSlots(currentEnd!, startTime)) {
          currentEnd = endTime;
        } else {
          groupedSlots.add(
              '${convertToAmPm(currentStart)} - ${convertToAmPm(currentEnd)}');
          currentStart = startTime;
          currentEnd = endTime;
        }
      }
    }

    // Add the last group if exists
    if (currentStart != null && currentEnd != null) {
      groupedSlots
          .add('${convertToAmPm(currentStart)} - ${convertToAmPm(currentEnd)}');
    }

    return groupedSlots;
  }

  static bool _areConsecutiveSlots(String endTime, String startTime) {
    return endTime == startTime;
  }

  static DateTime _extractDateTime(String formattedSlot) {
    final parts = formattedSlot.split(' | ');
    if (parts.length != 2) return DateTime.now();

    final datePart = parts[0];
    final timePart = parts[1].split(' - ')[0];

    try {
      // Convert 12-hour format to 24-hour format
      final time24Hour = _convertTo24Hour(timePart);
      final date = DateTime.parse('${datePart}T${time24Hour}:00');
      return date;
    } catch (e) {
      return DateTime.now();
    }
  }

  static String _convertTo24Hour(String time12) {
    final timeParts = time12.split(' ');
    if (timeParts.length != 2) return time12;

    final time = timeParts[0];
    final period = timeParts[1].toUpperCase();

    final hourMinute = time.split(':');
    if (hourMinute.length != 2) return time12;

    int hour = int.parse(hourMinute[0]);
    final minute = hourMinute[1];

    // Convert 12-hour to 24-hour
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute}';
  }

  static Map<String, String> parseSelectedSlot(String formattedSlot) {
    final parts = formattedSlot.split(' | ');
    if (parts.length != 2) {
      return {'date': '', 'time': ''};
    }

    return {
      'date': parts[0],
      'time': parts[1],
    };
  }
}
