import 'package:flutter/material.dart';
import '../../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../config/appointment_stats_data.dart';

class AppointmentStatsItem extends StatelessWidget {
  final AppointmentStatsData item;
  final bool isLast;
  final Color color;

  const AppointmentStatsItem({
    Key? key,
    required this.item,
    required this.color,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 9),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surface, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: _icon()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.black,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.count}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: colors.black,
                  height: 1.0,
                ),
              ),
              Text(
                '${item.percentage}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _icon() {
    final lower = item.label.toLowerCase();
    if (lower.contains('pending'))
      return Icon(Icons.access_time, size: 18, color: color);
    if (lower.contains('approved'))
      return Icon(Icons.check_circle_outline, size: 18, color: color);
    if (lower.contains('completed'))
      return Icon(Icons.check, size: 18, color: color);
    if (lower.contains('cancelled'))
      return Icon(Icons.cancel_outlined, size: 18, color: color);
    return Icon(Icons.info, size: 18, color: color);
  }
}
