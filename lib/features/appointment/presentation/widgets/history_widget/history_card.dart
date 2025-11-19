import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../data/models/appointment_model.dart';
import '../../utils/history_utils.dart';
import 'history_card_content.dart';

class HistoryCard extends StatelessWidget {
  final List<UserModel>? users;
  final AppointmentModel appointment;

  const HistoryCard({
    super.key,
    required this.appointment,
    this.users,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        child: InkWell(
          onTap: () => HistoryUtils.show(context, appointment, users),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.white.withOpacity(0.05),
              borderRadius: context.radii.small,
              border: Border.all(
                color: colors.textPrimary.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: HistoryCardContent(appointment: appointment),
          ),
        ),
      ),
    );
  }
}
