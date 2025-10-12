import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../pages/home_page.dart';
import '../appointment_card_widget/appointment_card.dart';
import 'home_history_button.dart';

class HomeAppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final HomePageState state;
  final Function(String) onCancel;
  final Function(String) onReschedule;

  const HomeAppointmentList({
    super.key,
    required this.appointments,
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
              final user = state.controller.getUserByIdNumber(
                appointment.reschedule.rescheduledBy ?? '',
              );

              return RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppointmentCard(
                    appointment: appointment,
                    onCancel: () => onCancel(appointment.appointmentId),
                    onReschedule: () => onReschedule(appointment.appointmentId),
                    user: user,
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
