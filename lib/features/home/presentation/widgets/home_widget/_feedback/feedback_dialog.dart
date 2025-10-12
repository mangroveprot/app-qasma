import 'package:flutter/material.dart';
import '../../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../../common/widgets/custom_modal/info_modal_dialog.dart';
import '../../../../../../theme/theme_extensions.dart';
import '../../../../../appointment/data/models/appointment_model.dart';

class FeedbackRequiredDialog {
  FeedbackRequiredDialog._();

  static Future<void> show({
    required BuildContext context,
    required AppointmentModel appointment,
    required VoidCallback onSubmitLater,
    required VoidCallback onSubmitNow,
    ButtonCubit? buttonCubit,
  }) {
    final colors = context.colors;

    return InfoModalDialog.show<ButtonCubit>(
      context: context,
      icon: Icons.star_rounded,
      title: 'How Did It Go?',
      subtitle: 'Your session just wrapped up! 🎉',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'We\'d love to hear about your experience! Your feedback helps us serve you better.',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _AppointmentDetailsCard(
            appointment: appointment,
            colors: colors,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.textPrimary.withOpacity(0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 15,
                      color: colors.textPrimary.withOpacity(0.5),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'You\'ll be redirected to JRMSU Feedback Form',
                        style: TextStyle(
                          color: colors.textPrimary.withOpacity(0.65),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: colors.textPrimary.withOpacity(0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Takes less than 2 minutes',
                      style: TextStyle(
                        color: colors.textPrimary.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      secondaryButtonText: 'I\'ll Do This Later',
      onSecondaryPressed: () {
        Navigator.of(context).pop();
        onSubmitLater();
      },
      primaryButtonText: 'Share My Feedback',
      onPrimaryPressed: onSubmitNow,
      buttonCubit: buttonCubit,
    );
  }
}

class _AppointmentDetailsCard extends StatelessWidget {
  final AppointmentModel appointment;
  final dynamic colors;

  const _AppointmentDetailsCard({
    required this.appointment,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors?.primary.withOpacity(0.08) ?? Colors.blue.withOpacity(0.08),
            colors?.primary.withOpacity(0.03) ?? Colors.blue.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              colors?.primary.withOpacity(0.2) ?? Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors?.primary.withOpacity(0.15) ??
                      Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.event_note_rounded,
                  size: 16,
                  color: colors?.primary ?? Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Session Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colors?.textPrimary ?? Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.category_outlined,
            label: 'Type',
            value: appointment.appointmentType,
            colors: colors,
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Icons.tag_outlined,
            label: 'Reference',
            value: appointment.appointmentId.substring(0, 16) + '...',
            colors: colors,
            isSubdued: true,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final dynamic colors;
  final bool isSubdued;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isSubdued = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isSubdued
              ? (colors?.textPrimary.withOpacity(0.4) ?? Colors.black38)
              : (colors?.textPrimary.withOpacity(0.6) ?? Colors.black54),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            color: colors?.textPrimary.withOpacity(0.6) ?? Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isSubdued
                  ? (colors?.textPrimary.withOpacity(0.5) ?? Colors.black45)
                  : (colors?.textPrimary ?? Colors.black87),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
