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
