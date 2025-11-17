import 'package:url_launcher/url_launcher.dart';

import '../utils/constant.dart';

class Field {
  final String field_key;

  const Field(this.field_key);
}

bool isPasswordValid(String password) {
  final regex = RegExp(r'^.{8,}$');
  return regex.hasMatch(password);
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isFacebookValid(String url) {
  final facebookRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?(facebook\.com|m\.facebook\.com|fb\.com)\/'
    r'([a-zA-Z0-9\.]+|profile\.php\?id=\d+)$',
    caseSensitive: false,
  );

  return facebookRegex.hasMatch(url.trim());
}

DateTime buildDateOfBirth({
  required String year,
  required String month,
  required String day,
  required List<String> monthsList,
}) {
  final yearInt = int.parse(year);
  final dayInt = int.parse(day);
  final monthInt = monthsList.indexOf(month) + 1;

  return DateTime(yearInt, monthInt, dayInt);
}

String convertToAmPm(String time) {
  final parts = time.split(':');
  var hour = int.parse(parts[0]);
  final minute = parts[1];
  final period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if (hour == 0) hour = 12;
  return '$hour:$minute $period';
}

String generateToastId(String prefix) {
  final now = DateTime.now();
  return '$prefix-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
      '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}_'
      '${now.millisecond}';
}

String capitalizeWords(String input) {
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

DateTime combineToLocalDateTime(String date, String time12h) {
  final dateParts = date.split('-');
  if (dateParts.length != 3) throw const FormatException('Invalid date format');

  final year = int.parse(dateParts[0]);
  final month = int.parse(dateParts[1]);
  final day = int.parse(dateParts[2]);

  final timeParts = time12h.split(' ');
  if (timeParts.length != 2) throw const FormatException('Invalid time format');

  final time = timeParts[0];
  final period = timeParts[1].toUpperCase(); // "AM" or "PM"

  final hourMinute = time.split(':');
  if (hourMinute.length != 2)
    throw const FormatException('Invalid time structure');

  int hour = int.parse(hourMinute[0]);
  final minute = int.parse(hourMinute[1]);

  // Convert 12-hour to 24-hour
  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return DateTime(year, month, day, hour, minute); // ← LOCAL time
}

DateTime stripMicroseconds(DateTime utcTime) {
  return DateTime(
    utcTime.year,
    utcTime.month,
    utcTime.day,
    utcTime.hour,
    utcTime.minute,
    utcTime.second,
  );
}

Map<String, DateTime> parseDateTimeRange(String input) {
  final parts = input.split('|');
  if (parts.length != 2) throw const FormatException('Invalid format');

  final datePart = parts[0].trim(); // e.g. "2025-08-06"
  final timeRange = parts[1].trim(); // e.g. "1:30 PM - 1:50 PM"
  final timeParts = timeRange.split('-');

  if (timeParts.length != 2) throw const FormatException('Invalid time range');

  final startTime = timeParts[0].trim(); // "1:30 PM"
  final endTime = timeParts[1].trim(); // "1:50 PM"

  final startDateTime = combineToLocalDateTime(datePart, startTime);
  final endDateTime = combineToLocalDateTime(datePart, endTime);

  return {
    'start': startDateTime,
    'end': endDateTime,
  };
}

String getTimeOfDayGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return 'Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Afternoon';
  } else {
    return 'Evening';
  }
}

enum DateTimeFormatStyle {
  timeOnly,
  dateOnly,
  dateAndTime,
}

String formatUtcToLocal({
  required String utcTime,
  DateTimeFormatStyle style = DateTimeFormatStyle.dateAndTime,
}) {
  try {
    final utcDateTime = DateTime.parse(utcTime);

    // Format time
    int hour = utcDateTime.hour;
    final minute = utcDateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final timeStr = '$hour:$minute $period';

    // Format date (MonthName Day, Year)
    final year = utcDateTime.year;
    final monthName = monthsList[utcDateTime.month - 1];
    final day = utcDateTime.day.toString().padLeft(2, '0');
    final dateStr = '$monthName $day, $year';

    switch (style) {
      case DateTimeFormatStyle.timeOnly:
        return timeStr;
      case DateTimeFormatStyle.dateOnly:
        return dateStr;
      case DateTimeFormatStyle.dateAndTime:
      default:
        return '$dateStr $timeStr';
    }
  } catch (e) {
    return 'Invalid time format';
  }
}

Future<void> launchExternalUrl({required Uri uri}) async {
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
