import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';

class AppointmentDetailsSection extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel? counselor;

  const AppointmentDetailsSection({
    super.key,
    required this.appointment,
    this.counselor,
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
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'Your Counselor: ',
                      style: labelTextStyle,
                    ),
                    TextSpan(
                      text: capitalizeWords(
                        counselor?.fullName ?? 'To be assigned.',
                      ),
                      style: subtitleTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Spacing.verticalSmall,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.category_outlined,
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
                      text: 'Purpose: ',
                      style: labelTextStyle,
                    ),
                    TextSpan(
                      text: '${capitalizeWords(
                        appointment.appointmentCategory,
                      )} - ${capitalizeWords(
                        appointment.appointmentType,
                      )}',
                      style: subtitleTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Spacing.verticalSmall,
        if (appointment.status.toString().toLowerCase() ==
            StatusType.approved.field.toLowerCase()) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
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
                        text: 'Location: ',
                        style: labelTextStyle,
                      ),
                      TextSpan(
                        text: 'Guidance Office',
                        style: subtitleTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]
      ],
    );
  }
}
