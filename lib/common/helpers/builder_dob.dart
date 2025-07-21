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
