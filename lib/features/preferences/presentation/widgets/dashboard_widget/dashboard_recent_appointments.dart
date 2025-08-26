import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../home/presentation/widgets/appointment_card_widget/status_chip.dart';
import '../../../../users/data/models/user_model.dart';

class DashboardRecentAppointments extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final List<UserModel> users;

  const DashboardRecentAppointments({
    Key? key,
    required this.appointments,
    required this.users,
  }) : super(key: key);

  UserModel? getUserById(String userId) {
    final matches = users.where((user) => user.idNumber == userId);
    return matches.isNotEmpty ? matches.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;

    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: radius.large,
        boxShadow: [
          BoxShadow(
            color: colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Text(
              'Recent Appointments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: fontWeight.bold,
                color: colors.black.withOpacity(0.8),
                letterSpacing: -0.2,
              ),
            ),
          ),
          // Appointments List
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: appointments.asMap().entries.map((entry) {
                final index = entry.key;
                final appointment = entry.value;
                final isLast = index == appointments.length - 1;
                final UserModel? getUser = getUserById(appointment.studentId);

                return Container(
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colors.secondary.withOpacity(0.1),
                          borderRadius: radius.medium,
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: colors.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Appointment Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    getUser?.fullName ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: fontWeight.medium,
                                      color: colors.black.withOpacity(0.8),
                                      letterSpacing: -0.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                StatusChip(
                                  status: appointment.status,
                                  fontSize: 10,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${appointment.appointmentCategory} - ${appointment.appointmentType}',
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textPrimary,
                                fontWeight: fontWeight.medium,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            // Text(
                            //   appointment['dateTime'] as String,
                            //   style: TextStyle(
                            //     fontSize: 13,
                            //     color: colors.textPrimary.withOpacity(0.7),
                            //     fontWeight: fontWeight.regular,
                            //   ),
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
