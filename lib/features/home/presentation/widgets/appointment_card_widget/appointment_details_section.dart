import 'package:flutter/material.dart';
import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';

class AppointmentDetailsSection extends StatelessWidget {
  final AppointmentModel appointment;
  final UserModel userModel;

  const AppointmentDetailsSection({
    super.key,
    required this.appointment,
    required this.userModel,
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                context: context,
                icon: Icons.badge_outlined,
                label: 'ID: ',
                value: userModel.idNumber,
                labelStyle: labelTextStyle,
                valueStyle: subtitleTextStyle,
                colors: colors,
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                context: context,
                icon: Icons.person_outline,
                label: 'Name: ',
                value: userModel.fullName,
                labelStyle: labelTextStyle,
                valueStyle: subtitleTextStyle,
                colors: colors,
              ),
              Spacing.verticalSmall,
              _buildDetailRow(
                context: context,
                icon: Icons.local_offer_outlined,
                label: 'Category: ',
                value: capitalizeWords(appointment.appointmentCategory),
                labelStyle: labelTextStyle,
                valueStyle: subtitleTextStyle,
                colors: colors,
              ),
              Spacing.verticalSmall,
              _buildDetailRow(
                context: context,
                icon: Icons.description_outlined,
                label: 'Description: ',
                value: appointment.description,
                labelStyle: labelTextStyle,
                valueStyle: subtitleTextStyle,
                colors: colors,
              ),
              Spacing.verticalXSmall,
              _buildDetailRow(
                context: context,
                icon: Icons.label_important_outline,
                label: 'Appointment Type: ',
                value: appointment.appointmentType,
                labelStyle: labelTextStyle,
                valueStyle: subtitleTextStyle,
                colors: colors,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required TextStyle labelStyle,
    required TextStyle valueStyle,
    required dynamic colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: colors.textPrimary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(text: label, style: labelStyle),
                TextSpan(text: value, style: valueStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
