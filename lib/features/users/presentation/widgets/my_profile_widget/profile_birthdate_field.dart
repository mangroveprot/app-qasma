import 'package:flutter/material.dart';

import '../../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class ProfileBirthdateField extends StatelessWidget {
  final ValueNotifier<String?> monthController;
  final ValueNotifier<String?> dayController;
  final ValueNotifier<String?> yearController;
  final bool isEnabled;
  final void Function(DateTime newDate)? onDateChanged;

  const ProfileBirthdateField({
    super.key,
    required this.monthController,
    required this.dayController,
    required this.yearController,
    this.isEnabled = true,
    this.onDateChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    if (!isEnabled) return;

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
      if (onDateChanged != null) onDateChanged!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radius = context.radii;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: radius.medium,
        border: Border.all(
          color: colors.black.withOpacity(0.25),
          width: 1.5,
        ),
        color: colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<String?>(
          valueListenable: monthController,
          builder: (_, month, __) => ValueListenableBuilder<String?>(
            valueListenable: dayController,
            builder: (_, day, ___) => ValueListenableBuilder<String?>(
              valueListenable: yearController,
              builder: (_, year, ____) {
                final hasDate = month != null && day != null && year != null;
                final displayText =
                    hasDate ? '$month $day, $year' : 'Not provided';

                return GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date of Birth',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: fontWeight.medium,
                                color: colors.textPrimary,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              displayText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: fontWeight.medium,
                                color: hasDate
                                    ? (isEnabled
                                        ? colors.black
                                        : colors.black.withOpacity(0.5))
                                    : colors.textPrimary.withOpacity(0.4),
                                fontStyle: hasDate
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: colors.textPrimary.withOpacity(0.6),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
