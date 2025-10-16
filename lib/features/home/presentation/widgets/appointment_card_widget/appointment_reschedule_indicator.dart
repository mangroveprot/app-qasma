import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/widgets/custom_modal/info_modal_dialog.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/reschedule_model.dart';
import '../../../../users/data/models/user_model.dart';

class AppointmentRescheduleIndicator extends StatelessWidget {
  final RescheduleModel reschedAppointment;
  final UserModel? user;

  const AppointmentRescheduleIndicator({
    super.key,
    required this.reschedAppointment,
    this.user,
  });

  void _showRescheduleDetails(BuildContext context) {
    InfoModalDialog.show(
      context: context,
      icon: Icons.refresh,
      title: 'Reschedule Information',
      subtitle: 'This appointment has been rescheduled',
      content: _buildContent(context),
      primaryButtonText: 'Got it',
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;

    final dateAndTime = '${formatUtcToLocal(
      utcTime: reschedAppointment.previousStart.toString(),
      style: DateTimeFormatStyle.dateOnly,
    )} '
        '${formatUtcToLocal(
      utcTime: reschedAppointment.previousStart.toString(),
      style: DateTimeFormatStyle.timeOnly,
    )} to '
        '${formatUtcToLocal(
      utcTime: reschedAppointment.previousEnd.toString(),
      style: DateTimeFormatStyle.timeOnly,
    )}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: colors.primary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Details about the reschedule:',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.primary,
                  fontWeight: fontWeight.medium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Reschedule details container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow(
                'Previous Schedule',
                dateAndTime,
                Icons.schedule,
                colors,
              ),
              const SizedBox(height: 8),
              _buildDataRow(
                'Rescheduled By',
                user?.fullName ?? 'N/A',
                Icons.person_outline,
                colors,
              ),
              if (reschedAppointment.remarks != null &&
                  reschedAppointment.remarks!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDataRow(
                  'Remarks',
                  reschedAppointment.remarks!,
                  Icons.note_outlined,
                  colors,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow(
    String label,
    String value,
    IconData icon,
    dynamic colors,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: colors.textPrimary,
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = SharedPrefs().getString('currentUserId');
    final isRescheduleByCurrUser =
        currentUserId == reschedAppointment.rescheduledBy;
    final colors = context.colors;
    final weight = context.weight;

    return GestureDetector(
      onTap: () => _showRescheduleDetails(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.refresh,
            size: 14,
            color: colors.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              reschedAppointment.rescheduledBy != null
                  ? 'Rescheduled by ${isRescheduleByCurrUser ? "you" : user?.role ?? ''}'
                  : 'Rescheduled',
              style: TextStyle(
                fontSize: 12,
                color: colors.primary,
                fontWeight: weight.regular,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 14,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}
