import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final Map<String, String> items;
  final IconData? icon;

  const InfoSection({
    super.key,
    required this.title,
    required this.items,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Container(
      decoration: BoxDecoration(
        color: colors.textPrimary.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.textPrimary.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: weight.medium,
                    color: colors.black,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.textPrimary.withOpacity(0.08)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items.entries.map((entry) {
                final isLast = entry.key == items.keys.last;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: weight.medium,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: weight.medium,
                            color: colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static IconData getIconForSection(String title) {
    if (title.toLowerCase().contains('appointment')) {
      return Icons.event_note_outlined;
    } else if (title.toLowerCase().contains('approval')) {
      return Icons.verified_outlined;
    } else if (title.toLowerCase().contains('check-in')) {
      return Icons.check_circle_outline;
    } else if (title.toLowerCase().contains('cancellation')) {
      return Icons.cancel_outlined;
    }
    return Icons.info_outline;
  }
}
