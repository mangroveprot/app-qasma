import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class HomeStatusCard extends StatelessWidget {
  const HomeStatusCard({
    super.key,
  });

  static final nowUtc = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: radii.medium,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: colors.primary),
                    const SizedBox(width: 6),
                    Text(
                        formatUtcToLocal(
                          utcTime: nowUtc.toString(),
                          style: DateTimeFormatStyle.dateOnly,
                        ),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: radii.medium,
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 10,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
