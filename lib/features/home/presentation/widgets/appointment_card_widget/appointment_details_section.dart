import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';

class AppointmentDetailsSection extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetailsSection({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    final labelTextStyle = TextStyle(
      fontSize: 14,
      color: colors.black,
      fontWeight: weight.medium,
    );

    final subtitleTextStyle = TextStyle(
      fontSize: 12,
      color: colors.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category with icon
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
                      style: labelTextStyle,
                    ),
                    TextSpan(
                      text: capitalizeWords(appointment.appointmentCategory),
                      style: subtitleTextStyle,
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
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'Description: ',
                      style: labelTextStyle,
                    ),
                    TextSpan(
                      text: appointment.description,
                      style: subtitleTextStyle,
                    ),
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
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'Appointment Type: ',
                      style: labelTextStyle,
                    ),
                    TextSpan(
                      text: appointment.appointmentType,
                      style: subtitleTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
