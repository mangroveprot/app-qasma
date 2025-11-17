import 'package:flutter/material.dart';
import '../../../../../../common/utils/button_ids.dart';
import '../../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../../common/widgets/custom_modal/info_modal_dialog.dart';
import '../../../../../../theme/theme_extensions.dart';

class FeedbackDialog {
  FeedbackDialog._();

  static Future<void> show({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? description,
    Widget? detailsCard,
    String? redirectMsg,
    String? estimatedTime,
    String? secondaryBtnText,
    required VoidCallback onSecondary,
    required VoidCallback onPrimary,
    ButtonCubit? buttonCubit,
  }) {
    final colors = context.colors;

    return InfoModalDialog.show(
      context: context,
      icon: Icons.star_rounded,
      title: title ?? 'Share Your Feedback',
      subtitle: subtitle ?? 'We value your opinion! 💭',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description ?? 'Your feedback helps us improve our services.',
            style:
                TextStyle(color: colors.textPrimary, fontSize: 14, height: 1.4),
            textAlign: TextAlign.center,
          ),
          if (detailsCard != null) ...[const SizedBox(height: 16), detailsCard],
          const SizedBox(height: 12),
          _buildInfoBox(colors, redirectMsg, estimatedTime),
        ],
      ),
      secondaryButtonText: secondaryBtnText ?? 'Cancel',
      onSecondaryPressed: () {
        Navigator.of(context).pop();
        onSecondary();
      },
      primaryButtonText: 'Share My Feedback',
      onPrimaryPressed: onPrimary,
      buttonCubit: buttonCubit,
      buttonId: ButtonsUniqeKeys.feedback.id,
    );
  }

  static Widget _buildInfoBox(
      dynamic colors, String? redirectMsg, String? time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.textPrimary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.info_outline,
            redirectMsg ?? 'You\'ll be redirected to JRMSU Feedback Form',
            colors,
            15,
          ),
          if (time != null) ...[
            const SizedBox(height: 6),
            _buildInfoRow(Icons.schedule, time, colors, 14, isSubdued: true),
          ],
        ],
      ),
    );
  }

  static Widget _buildInfoRow(
      IconData icon, String text, dynamic colors, double iconSize,
      {bool isSubdued = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,
            size: iconSize,
            color: colors.textPrimary.withOpacity(isSubdued ? 0.4 : 0.5)),
        SizedBox(width: isSubdued ? 4 : 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: colors.textPrimary.withOpacity(isSubdued ? 0.5 : 0.65),
              fontSize: isSubdued ? 11 : 12,
              fontWeight: isSubdued ? FontWeight.normal : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // For appointment feedback
  static Future<void> showForAppointment({
    required BuildContext context,
    required dynamic appointment,
    required VoidCallback onLater,
    required VoidCallback onNow,
    ButtonCubit? buttonCubit,
  }) {
    return show(
      context: context,
      title: 'How Did It Go?',
      subtitle: 'Your session just wrapped up! 🎉',
      description:
          'We\'d love to hear about your experience! Your feedback helps us serve you better.',
      detailsCard: _AppointmentCard(appointment, context.colors),
      redirectMsg: 'You\'ll be redirected to JRMSU Feedback Form',
      estimatedTime: 'Takes less than 2 minutes',
      secondaryBtnText: 'I\'ll Do This Later',
      onSecondary: onLater,
      onPrimary: onNow,
      buttonCubit: buttonCubit,
    );
  }

  // For general feedback (menu)
  static Future<void> showGeneral({
    required BuildContext context,
    required VoidCallback onSubmit,
    VoidCallback? onCancel,
    ButtonCubit? buttonCubit,
  }) {
    return show(
      context: context,
      redirectMsg: 'You\'ll be redirected to JRMSU Feedback Form',
      estimatedTime: 'Takes less than 2 minutes',
      onSecondary: onCancel ?? () {},
      onPrimary: onSubmit,
      buttonCubit: buttonCubit,
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final dynamic appointment;
  final dynamic colors;

  const _AppointmentCard(this.appointment, this.colors);

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
            color: colors?.primary.withOpacity(0.2) ??
                Colors.blue.withOpacity(0.2)),
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
                child: Icon(Icons.event_note_rounded,
                    size: 16, color: colors?.primary ?? Colors.blue),
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
          _DetailRow(Icons.category_outlined, 'Type',
              appointment.appointmentType ?? 'N/A', colors),
          const SizedBox(height: 6),
          _DetailRow(
            Icons.tag_outlined,
            'Reference',
            '${appointment.appointmentId.substring(0, 16)}...',
            colors,
            true,
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

  const _DetailRow(this.icon, this.label, this.value, this.colors,
      [this.isSubdued = false]);

  @override
  Widget build(BuildContext context) {
    final opacity = isSubdued ? 0.4 : 0.6;
    final valueOpacity = isSubdued ? 0.5 : 1.0;

    return Row(
      children: [
        Icon(icon,
            size: 14,
            color: colors?.textPrimary.withOpacity(opacity) ?? Colors.black54),
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
              color: colors?.textPrimary.withOpacity(valueOpacity) ??
                  Colors.black87,
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
