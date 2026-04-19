import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../home/presentation/widgets/appointment_card_widget/status_chip.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../data/models/appointment_model.dart';

class HistoryCardContent extends StatelessWidget {
  final AppointmentModel appointment;
  final List<UserModel>? users;

  const HistoryCardContent({
    super.key,
    required this.appointment,
    this.users,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final status = appointment.status;

    final Map<String, UserModel> userById = {
      for (final user in users ?? const <UserModel>[]) user.idNumber: user,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors.textPrimary.withOpacity(0.05),
            borderRadius: radius.small,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: colors.textPrimary,
              ),
              const SizedBox(width: 4),
              Text(
                formatUtcToLocal(
                  utcTime: appointment.scheduledStartAt.toString(),
                  style: DateTimeFormatStyle.dateOnly,
                ),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: weight.medium,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Spacing.verticalSmall,

        // Student info
        Builder(
          builder: (context) {
            final user = userById[appointment.studentId];
            if (user == null) return const SizedBox.shrink();
            final displayName = user.fullName.trim().isNotEmpty
                ? user.fullName.trim()
                : 'Unknown';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: weight.bold,
                    color: colors.black.withOpacity(0.9),
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Spacing.verticalSmall,
              ],
            );
          },
        ),

        // Category and status row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: StatusType.cancelled == status
                    ? colors.primary.withOpacity(0.05)
                    : colors.error.withOpacity(0.05),
                borderRadius: radius.small,
              ),
              child: Icon(
                Icons.local_offer_outlined,
                size: 20,
                color: StatusType.cancelled == status
                    ? colors.primary
                    : colors.error,
              ),
            ),
            Spacing.horizontalSmall,
            Expanded(
              child: Text(
                capitalizeWords(appointment.appointmentCategory),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: weight.medium,
                  color: colors.black,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            StatusChip(status: status),
          ],
        ),
        Spacing.verticalMedium,

        // Time row
        Row(
          children: [
            // Start time
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.textPrimary.withOpacity(0.05),
                borderRadius: radius.small,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: colors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatUtcToLocal(
                      utcTime: appointment.scheduledStartAt.toString(),
                      style: DateTimeFormatStyle.timeOnly,
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: weight.medium,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // End time
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.textPrimary.withOpacity(0.05),
                borderRadius: radius.small,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 14,
                    color: colors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatUtcToLocal(
                      utcTime: appointment.scheduledEndAt.toString(),
                      style: DateTimeFormatStyle.timeOnly,
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: weight.medium,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Chevron
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors.textPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
