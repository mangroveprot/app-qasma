import 'package:flutter/material.dart';

import '../utils/constant.dart';

class Field {
  final String field_key;

  const Field(this.field_key);
}

bool isPasswordValid(String password) {
  final regex = RegExp(r'^.{8,}$');
  return regex.hasMatch(password);
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

String generateToastId(String prefix) {
  final now = DateTime.now();
  return '$prefix-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
      '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}_'
      '${now.millisecond}';
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
    final utcDateTime = DateTime.parse(utcTime).toUtc();
    final localDateTime = utcDateTime.toLocal();

    // Format time
    int hour = localDateTime.hour;
    final minute = localDateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final timeStr = '$hour:$minute $period';

    // Format date (MonthName Day, Year)
    final year = localDateTime.year;
    final monthName = monthsList[localDateTime.month - 1];
    final day = localDateTime.day.toString().padLeft(2, '0');
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

// TODO: Make this functional
Map<String, String> buildValidationFields(
  List<Field> fields,
  Map<String, TextEditingController> textControllers,
) {
  final values = <String, String>{};

  for (final field in fields) {
    values[field.field_key] = textControllers[field.field_key]?.text ?? '';
  }

  return values;
}
