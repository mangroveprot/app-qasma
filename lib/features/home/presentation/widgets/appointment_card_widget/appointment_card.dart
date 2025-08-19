import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import 'card_approved_button.dart';
import 'card_cancel_button.dart';
import 'card_reschedule_button.dart';
import 'status_chip.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel userModel;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;
  final VoidCallback onApproved;
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onReschedule,
    required this.userModel,
    required this.onApproved,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final textPrimay = colors.textPrimary;

    final appointmentId = appointment.appointmentId;

    final _divider = Container(
      height: 1,
      color: textPrimay.withOpacity(0.1),
    );

    final _labelTextStyle =
        TextStyle(fontSize: 14, color: colors.black, fontWeight: weight.medium);

    final _subtitleTextStyle = TextStyle(
      fontSize: 12,
      color: textPrimay,
    );

    final _titleTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: weight.bold,
      color: colors.black,
    );

    return Card(
      elevation: 4,
      color: colors.white,
      surfaceTintColor: colors.white,
      shadowColor: colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: radius.large,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // date/time and status
            Row(
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
                            color: colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatUtcToLocal(
                                utcTime:
                                    appointment.scheduledStartAt.toString(),
                                style: DateTimeFormatStyle.dateOnly),
                            style: _titleTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${formatUtcToLocal(utcTime: appointment.scheduledStartAt.toString(), style: DateTimeFormatStyle.timeOnly)} - '
                            '${formatUtcToLocal(
                              utcTime: appointment.scheduledEndAt.toString(),
                              style: DateTimeFormatStyle.timeOnly,
                            )}',
                            style: _subtitleTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                StatusChip(status: appointment.status),
              ],
            ),

            Spacing.verticalMedium,
            _divider,
            Spacing.verticalMedium,

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // left side - Appointment info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'ID: ', style: _labelTextStyle),
                                  TextSpan(
                                      text: userModel.idNumber,
                                      style: _subtitleTextStyle),
                                ],
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Name: ', style: _labelTextStyle),
                                  TextSpan(
                                      text: userModel.fullName,
                                      style: _subtitleTextStyle),
                                ],
                              ),
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      Spacing.verticalSmall,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'Category: ',
                                    style: _labelTextStyle,
                                  ),
                                  TextSpan(
                                    text: capitalizeWords(
                                        appointment.appointmentCategory),
                                    style: _subtitleTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacing.verticalSmall,

                      // Description with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style, // base style
                                children: [
                                  TextSpan(
                                      text: 'Description: ',
                                      style: _labelTextStyle),
                                  TextSpan(
                                      text: appointment.description,
                                      style: _subtitleTextStyle),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacing.verticalXSmall,

                      // Appointment Type with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.label_important_outline,
                            size: 16,
                            color: colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style, // base style
                                children: [
                                  TextSpan(
                                      text: 'Appointment Type: ',
                                      style: _labelTextStyle),
                                  TextSpan(
                                      text: appointment.appointmentType,
                                      style: _subtitleTextStyle),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Spacing.verticalMedium,
            _divider,
            Spacing.verticalMedium,

            Row(
              children: [
                if (appointment.status != StatusType.approved.status) ...[
                  Expanded(
                    child: CardApproveButton(
                      buttonId: 'approved${appointmentId}',
                      onPressed: onApproved,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: CardRescheduleButton(
                    buttonId: 'reschedule_${appointmentId}',
                    onPressed: onReschedule,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CardCancelButton(
                    buttonId: 'cancel${appointmentId}',
                    onPressed: onCancel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
