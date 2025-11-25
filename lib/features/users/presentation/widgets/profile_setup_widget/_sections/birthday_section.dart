import 'package:flutter/material.dart';

import '../../../../../../common/utils/constant.dart';
import '../../../../../../infrastructure/theme/theme_extensions.dart';

class BirthdateSection extends StatelessWidget {
  final ValueNotifier<String?> monthController;
  final ValueNotifier<String?> dayController;
  final ValueNotifier<String?> yearController;

  const BirthdateSection({
    super.key,
    required this.monthController,
    required this.dayController,
    required this.yearController,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();

    DateTime? initialDate;
    try {
      final y = int.tryParse(yearController.value ?? '');
      final m = monthsList.indexOf(monthController.value ?? '') + 1;
      final d = int.tryParse(dayController.value ?? '');
      if (y != null && m > 0 && d != null) {
        initialDate = DateTime(y, m, d);
      }
    } catch (_) {}

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );

    if (picked != null) {
      monthController.value = monthsList[picked.month - 1];
      dayController.value = picked.day.toString();
      yearController.value = picked.year.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth:',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 14,
            fontWeight: context.weight.medium,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<String?>(
          valueListenable: monthController,
          builder: (_, month, __) => ValueListenableBuilder<String?>(
            valueListenable: dayController,
            builder: (_, day, __) => ValueListenableBuilder<String?>(
              valueListenable: yearController,
              builder: (_, year, __) {
                final hasDate = month != null && day != null && year != null;
                final displayText =
                    hasDate ? '$month $day, $year' : 'Select a date';

                return GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayText,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  hasDate ? colors.black : colors.textPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
