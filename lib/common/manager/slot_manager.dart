import '../helpers/helpers.dart';

class SlotManager {
  static List<String> formatSlotsForDropdown(Map<String, dynamic> slotsData) {
    final List<String> formattedSlots = [];

    if (slotsData.isEmpty) return formattedSlots;

    slotsData.forEach((date, timeSlots) {
      if (timeSlots is List) {
        final List<String> slots = List<String>.from(timeSlots);

        for (final slot in slots) {
          final parts = slot.split(' - ');
          if (parts.length == 2) {
            final startTime = convertToAmPm(parts[0]);
            final endTime = convertToAmPm(parts[1]);
            formattedSlots.add('$date | $startTime - $endTime');
          }
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

  static DateTime _extractDateTime(String formattedSlot) {
    final parts = formattedSlot.split(' | ');
    if (parts.length != 2) return DateTime.now();

    final datePart = parts[0];
    final timePart = parts[1].split(' - ')[0];

    try {
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

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:$minute';
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
