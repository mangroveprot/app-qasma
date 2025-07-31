import 'package:flutter/material.dart';

class Field {
  final String field_key;

  const Field(this.field_key);
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
