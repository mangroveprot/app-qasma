import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import 'card_cancel_button.dart';
import 'card_qrcode_section.dart';
import 'card_reschedule_button.dart';
import 'status_chip.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;
  const AppointmentCard(
      {super.key,
      required this.appointment,
      required this.onCancel,
      required this.onReschedule});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final textPrimay = colors.textPrimary;

    final _divider = Container(
      height: 1,
      color: textPrimay,
    );



    final _labelTextStyle =
        TextStyle(fontSize: 14, color: colors.black, fontWeight: weight.medium);
    final _subtitleTextStyle = TextStyle(
      fontSize: 14,
      color: textPrimay,
    );

    final _titleTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: weight.bold,
      color: colors.black,
    );

    return Card(
      elevation: 2,
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
                      Text(
                        appointment.scheduledStartAt.toString(),
                        style: _titleTextStyle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.scheduledEndAt.toString(),
                        style: _subtitleTextStyle,
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
                      Text(
                        'Appointment Category:',
                        style: _labelTextStyle,
                      ),
                      Text(
                        appointment.appointmentType,
                        style: _subtitleTextStyle,
                      ),
                      Spacing.verticalSmall,
                      RichText(
                        text: TextSpan(
                          style:
                              DefaultTextStyle.of(context).style, // base style
                          children: [
                            TextSpan(
                                text: 'Description: ', style: _labelTextStyle),
                            TextSpan(
                                text: appointment.description,
                                style: _subtitleTextStyle),
                          ],
                        ),
                      ),
                      Spacing.verticalXSmall,
                      RichText(
                        text: TextSpan(
                          style:
                              DefaultTextStyle.of(context).style, // base style
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
                    ],
                  ),
                ),

                Spacing.horizontalMedium,

                const CardQRCodeSection(),
              ],
            ),

            Spacing.verticalLarge,
            _divider,
            Spacing.verticalMedium,

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardRescheduleButton(onPressed: onReschedule),
                Spacing.verticalSmall,
                RepaintBoundary(child: CardCancelButton(onPressed: onCancel))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
