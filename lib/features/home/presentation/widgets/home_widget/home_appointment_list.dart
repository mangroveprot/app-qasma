import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import '../../pages/home_page.dart';
import '../appointment_card_widget/appointment_card.dart';
import 'home_history_button.dart';

class HomeAppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final List<UserModel> users;
  final HomePageState state;
  final Function(String) onCancel;
  final Function(String) onReschedule;

  const HomeAppointmentList({
    super.key,
    required this.appointments,
    required this.users,
    required this.onCancel,
    required this.onReschedule,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Column(
      children: [
        // label
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 16, 0, 12),
          child: Text(
            'My Appointment',
            style: TextStyle(
              fontSize: 14,
              fontWeight: weight.medium,
              color: colors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: appointments.length + 1,
            itemBuilder: (context, index) {
              if (index == appointments.length) {
                return const HomeHistoryButton();
              }

              final appointment = appointments[index];

              final Map<String, UserModel> userMap = {
                for (final u in users) u.idNumber: u,
              };

              final UserModel? student = userMap[appointment.studentId];

              final String? counselorLookupId =
                  (appointment.counselorId != null &&
                          appointment.counselorId!.isNotEmpty)
                      ? appointment.counselorId
                      : null;

              final UserModel? counselor =
                  counselorLookupId != null ? userMap[counselorLookupId] : null;

              final UserModel? rescheduledBy =
                  userMap[appointment.reschedule.rescheduledBy];

              return RepaintBoundary(
                key: ValueKey('${appointment.appointmentId}'),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppointmentCard(
                    key: ValueKey('${appointment.appointmentId}'),
                    appointment: appointment,
                    student: student,
                    counselor: counselor,
                    rescheduledByUser: rescheduledBy,
                    onCancel: () => onCancel(appointment.appointmentId),
                    onReschedule: () => onReschedule(appointment.appointmentId),
                    onBackPressed: state.controller.appoitnmentRefreshData,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
