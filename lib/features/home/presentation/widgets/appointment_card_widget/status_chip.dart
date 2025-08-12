import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    final isApproved = status.toLowerCase() == 'approved';
    final isPending = status.toLowerCase() == 'pending';
    final isCompleted = status.toLowerCase() == 'completed';

    Color textColor;
    Color backgroundColor;
    String statusText;

    if (isApproved) {
      textColor = colors.primary;
      backgroundColor = colors.primary.withOpacity(0.1);
      statusText = 'Approved';
    } else if (isPending) {
      textColor = colors.warning;
      backgroundColor = colors.warning.withOpacity(0.1);
      statusText = 'Pending';
    } else if (isCompleted) {
      textColor = colors.primary;
      backgroundColor = colors.primary.withOpacity(0.1);
      statusText = 'Completed';
    } else {
      textColor = colors.error;
      backgroundColor = colors.error.withOpacity(0.1);
      statusText = 'Cancelled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: weight.medium,
          color: textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
