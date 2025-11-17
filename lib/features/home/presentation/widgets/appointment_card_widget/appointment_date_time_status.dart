import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../appointment/data/models/reschedule_model.dart';
import '../../../../users/data/models/user_model.dart';
import 'appointment_reschedule_indicator.dart';
import 'status_chip.dart';

class AppointmentDateTimeStatus extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel? user;
  final UserModel? rescheduledByUser;
  final bool isOverdue;
  final bool isOnSession;

  const AppointmentDateTimeStatus({
    super.key,
    required this.appointment,
    this.user,
    required this.isOverdue,
    required this.isOnSession,
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

    final subtitleTextStyle = TextStyle(
      fontSize: 12,
      color: textPrimary,
    );

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
                    size: 16,
                    color: isOverdue
                        ? colors.error.withOpacity(0.7)
                        : isOnSession
                            ? colors.primary
                            : colors.black,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointmentDate,
                      style: TextStyle(
                        fontSize: appointmentDate.length <= 15 ? 16 : 14,
                        fontWeight: weight.bold,
                        color: isOverdue
                            ? colors.error.withOpacity(0.7)
                            : isOnSession
                                ? colors.primary
                                : colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: isOverdue
                        ? colors.error
                        : isOnSession
                            ? colors.primary
                            : colors.textPrimary,
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
                            ? colors.error
                            : isOnSession
                                ? colors.primary
                                : textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              if (appointment.reschedule.rescheduledBy != null) ...[
                const SizedBox(height: 4),
                AppointmentRescheduleIndicator(
                  reschedAppointment: appointment.reschedule as RescheduleModel,
                  user: rescheduledByUser,
                )
              ]
            ],
          ),
        ),
        StatusChip(status: appointment.status),
      ],
    );
  }
}
