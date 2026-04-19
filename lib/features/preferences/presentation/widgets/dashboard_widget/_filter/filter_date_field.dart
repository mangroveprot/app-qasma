import 'package:flutter/material.dart';

import '../../../../../../infrastructure/theme/theme_extensions.dart';

class FilterDateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const FilterDateField({
    Key? key,
    required this.label,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary.withOpacity(0.55),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: date != null
                    ? colors.primary.withOpacity(0.4)
                    : colors.surface,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: date != null
                      ? colors.primary
                      : colors.textPrimary.withOpacity(0.4),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date!) : 'Select',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: date != null
                          ? colors.black
                          : colors.textPrimary.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}
