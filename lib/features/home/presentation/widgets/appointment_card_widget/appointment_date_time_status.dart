import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/data/models/reschedule_model.dart';
import '../../../../users/data/models/user_model.dart';
import 'appointment_reschedule_indicator.dart';
import 'status_chip.dart';
import 'verify_chip.dart';

class AppointmentDateTimeStatus extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onVerify;
  final UserModel? user;
  final UserModel? rescheduledByUser;
  final bool isCurrentSessions;
  final bool isOverdue;
  final bool isOnSession;

  const AppointmentDateTimeStatus({
    super.key,
    required this.appointment,
    this.user,
    required this.isOverdue,
    required this.isOnSession,
    required this.onVerify,
    required this.isCurrentSessions,
    this.rescheduledByUser,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final textPrimary = colors.textPrimary;
    final appointmentDate = formatUtcToLocal(
      utcTime: appointment.scheduledStartAt.toString(),
      style: DateTimeFormatStyle.dateOnly,
    );

    final metaColor = textPrimary.withOpacity(0.65);
    final subtitleTextStyle = TextStyle(
      fontSize: 11.5,
      color: metaColor,
      height: 1.15,
    );

    final Color accentColor = isOverdue
        ? colors.error.withOpacity(0.8)
        : isOnSession
            ? colors.primary.withOpacity(0.9)
            : metaColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointmentDate,
                      style: TextStyle(
                        fontSize: appointmentDate.length <= 15 ? 13.5 : 12.5,
                        fontWeight: weight.medium,
                        color: isOverdue
                            ? colors.error.withOpacity(0.85)
                            : isOnSession
                                ? colors.primary.withOpacity(0.95)
                                : textPrimary.withOpacity(0.85),
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: accentColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${formatUtcToLocal(utcTime: appointment.scheduledStartAt.toString(), style: DateTimeFormatStyle.timeOnly)} - '
                      '${formatUtcToLocal(
                        utcTime: appointment.scheduledEndAt.toString(),
                        style: DateTimeFormatStyle.timeOnly,
                      )}',
                      style: subtitleTextStyle.copyWith(
                        color: isOverdue
                            ? colors.error.withOpacity(0.8)
                            : isOnSession
                                ? colors.primary.withOpacity(0.85)
                                : metaColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (appointment.reschedule.rescheduledBy != null) ...[
                const SizedBox(height: 3),
                AppointmentRescheduleIndicator(
                  reschedAppointment: appointment.reschedule as RescheduleModel,
                  user: rescheduledByUser,
                )
              ]
            ],
          ),
        ),
        if (isCurrentSessions) ...[
          VerifyChip(
            onPressed: onVerify,
          )
        ] else ...[
          StatusChip(status: appointment.status)
        ],
      ],
    );
  }
}
