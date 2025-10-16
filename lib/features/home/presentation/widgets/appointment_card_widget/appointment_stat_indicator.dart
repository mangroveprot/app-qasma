import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class AppointmentStatIndicator extends StatelessWidget {
  final bool isOnSession;
  final bool isOverdue;

  const AppointmentStatIndicator({
    super.key,
    required this.isOnSession,
    required this.isOverdue,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOnSession && !isOverdue) return const SizedBox.shrink();

    final colors = context.colors;
    final fontWeight = context.weight;
    final bool isCurrentSession = isOnSession && !isOverdue;

    Color statusColor;
    IconData? statusIcon;
    String statusText;

    if (isOverdue) {
      statusColor = colors.error;
      statusIcon = Icons.error_outline;
      statusText = 'Overdue';
    } else if (isCurrentSession) {
      statusColor = colors.primary;
      statusIcon = null;
      statusText = 'Currently in session';
    } else {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (statusIcon != null)
                Icon(
                  statusIcon,
                  size: 12,
                  color: statusColor,
                )
              else
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: isOverdue ? 11 : 12,
                  color: statusColor,
                  fontWeight: fontWeight.medium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
