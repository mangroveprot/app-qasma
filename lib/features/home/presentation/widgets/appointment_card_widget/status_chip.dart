import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';
import '../../../data/models/appointment_model.dart';

class StatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final isApproved = status == AppointmentStatus.approved;
    final isPending = status == AppointmentStatus.pending;

    Color textColor;
    String statusText;

    if (isApproved) {
      textColor = colors.primary;
      statusText = 'APPROVED';
    } else if (isPending) {
      textColor = colors.warning;
      statusText = 'PENDING';
    } else {
      textColor = colors.error;
      statusText = 'CANCELLED';
    }

    return Text(
      statusText,
      style: TextStyle(
        fontSize: 12,
        fontWeight: weight.bold,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
