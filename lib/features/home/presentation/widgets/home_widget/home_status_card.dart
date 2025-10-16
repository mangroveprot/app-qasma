import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';

class HomeStatusCard extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const HomeStatusCard({
    super.key,
    required this.appointments,
  });

  static final nowUtc = DateTime.now().toUtc();

  int get _pendingAppointmentsCount {
    return appointments.where((appointment) {
      return appointment.status == StatusType.pending.field;
    }).length;
  }

  String get _pendingAppointmentsText {
    final count = _pendingAppointmentsCount;
    if (count == 1) return '1 appointment waiting for approval';
    return '$count appointments waiting for approval';
  }

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

            if (_pendingAppointmentsCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pending_actions,
                      size: 14,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _pendingAppointmentsText,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.primary,
                          fontWeight: weight.medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
