import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class HomeStatusCard extends StatelessWidget {
  final int approvedCount;
  final int pendingCount;
  const HomeStatusCard({
    super.key,
    required this.approvedCount,
    required this.pendingCount,
  });

  static final nowUtc = DateTime.now().toUtc();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final weight = context.weight;
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
            const SizedBox(height: 16),

            // Status Grid
            Row(
              children: [
                Expanded(
                  child: _statusItem(
                    icon: Icons.check_circle,
                    label: 'Approved',
                    count: approvedCount.toString(),
                    color: colors.primary,
                    fontWeight: weight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _statusItem(
                    icon: Icons.schedule,
                    label: 'Pending',
                    count: pendingCount.toString(),
                    color: colors.warning,
                    fontWeight: weight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusItem({
    required FontWeight fontWeight,
    required IconData icon,
    required String label,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              count,
              style: TextStyle(
                fontSize: 10,
                fontWeight: fontWeight,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
