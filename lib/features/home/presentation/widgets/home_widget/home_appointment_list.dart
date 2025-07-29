import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../data/models/appointment_model.dart';
import '../appointment_card_widget/appointment_card.dart';

class HomeAppointmentList extends StatelessWidget {
  final List<AppointmentData> appointments;
  final Function(String) onCancel;
  final Function(String) onReschedule;

  const HomeAppointmentList({
    super.key,
    required this.appointments,
    required this.onCancel,
    required this.onReschedule,
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

        // appointments list
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppointmentCard(
                    appointment: appointments[index],
                    onCancel: () => onCancel(appointments[index].id),
                    onReschedule: () => onReschedule(appointments[index].id),
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
