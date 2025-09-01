import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../home/presentation/widgets/appointment_card_widget/status_chip.dart';
import '../../../data/models/appointment_model.dart';
import 'history_modal_section.dart';
import 'info_section.dart';

class HistoryCard extends StatelessWidget {
  final AppointmentModel appointment;

  const HistoryCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final status = appointment.status;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: () => _showAppointmentDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.white.withOpacity(0.05),
              borderRadius: radius.small,
              border: Border.all(
                color: colors.textPrimary.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

                    // Category
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

                    // status chip
                    StatusChip(
                      status: appointment.status,
                    ),
                  ],
                ),

                Spacing.verticalMedium,

                // Date and time row
                Row(
                  children: [
                    // start time
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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

                    // end time
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
            ),
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context) {
    String safe(String? value) => value?.isNotEmpty == true ? value! : 'N/A';

    String safeDate(String? dateString, DateTimeFormatStyle style) {
      if (dateString?.isNotEmpty != true) return 'N/A';
      try {
        return formatUtcToLocal(utcTime: dateString!, style: style);
      } catch (e) {
        return 'N/A';
      }
    }

    HistoryModalSection.show(
      context,
      title: 'Appointment Details',
      child: Column(
        children: [
          InfoSection(
            title: 'Appointment Information',
            items: {
              'Category': safe(appointment.appointmentCategory.toString()),
              'Type': safe(appointment.appointmentType.toString()),
              'Status': safe(appointment.status.toString()),
              'Date': safeDate(appointment.scheduledStartAt.toString(),
                  DateTimeFormatStyle.dateOnly),
              'Start Time': safeDate(appointment.scheduledStartAt.toString(),
                  DateTimeFormatStyle.timeOnly),
              'End Time': safeDate(appointment.scheduledEndAt.toString(),
                  DateTimeFormatStyle.timeOnly),
            },
          ),
          Spacing.verticalMedium,
          InfoSection(
            title: 'Approval Information',
            items: {
              'Approved By': safe(appointment.staffId.toString()),
              'Assigned To': safe(appointment.counselorId.toString()),
            },
          ),
          Spacing.verticalMedium,
          InfoSection(
            title: 'Check-in Information',
            items: {
              'Check-in-status': safe(appointment.checkInStatus.toString()),
              'Check-in-at': safeDate(
                appointment.checkInTime?.toString(),
                DateTimeFormatStyle.dateAndTime,
              ),
              'Scanned By': safe(
                appointment.qrCode.token?.toString(),
              ),
              'Scanned At': safeDate(
                appointment.qrCode.scannedAt?.toString(),
                DateTimeFormatStyle.dateAndTime,
              ),
            },
          ),
          Spacing.verticalMedium,
          InfoSection(
            title: 'Cancellation Information',
            items: {
              'Reason': safe(appointment.cancellation.reason?.toString()),
              'Cancelled At': safeDate(
                  appointment.cancellation.cancelledAt?.toString(),
                  DateTimeFormatStyle.dateAndTime),
              'Cancelled By': safe(
                appointment.cancellation.cancelledById?.toString(),
              ),
            },
          ),
          Spacing.verticalLarge,
        ],
      ),
    );
  }
}
