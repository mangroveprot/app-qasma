import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import '../../pages/home_page.dart';
import '../appointment_card_widget/appointment_card.dart';
import '../home_skeletal_loader.dart';
import 'home_history_button.dart';

class HomeAppointmentList extends StatefulWidget {
  final HomePageState state;
  final List<AppointmentModel> appointments;
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
  State<HomeAppointmentList> createState() => _HomeAppointmentListState();
}

class _HomeAppointmentListState extends State<HomeAppointmentList> {
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
            'Appointments',
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
            itemCount: widget.appointments.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.appointments.length) {
                return const HomeHistoryButton();
              }

              final appointment = widget.appointments[index];
              final user = widget.state.controller
                  .getUserByIdNumber(appointment.studentId);
              if (user == null) {
                return HomeSkeletonLoader.appointmentCardSkeleton();
              }

              final UserModel userData = user;

              final appointmentId = widget.appointments[index].appointmentId;

              return RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppointmentCard(
                    key: ValueKey(appointmentId),
                    userModel: userData,
                    appointment: widget.appointments[index],
                    onApproved: () => widget.state.controller
                        .handleApprovedAppointment(context, appointmentId),
                    onCancel: () => widget.state.controller
                        .handleCancelAppointment(appointmentId, context),
                    onReschedule: () => widget.state.controller
                        .handleRescheduleAppointment(appointmentId),
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
