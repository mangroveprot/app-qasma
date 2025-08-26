import 'package:flutter/material.dart';

import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../appointment/data/models/appointment_model.dart';
import '../../../../users/data/models/user_model.dart';
import '../../utils/dashboard_utils.dart';

class DashboardStats extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final List<UserModel> users;

  const DashboardStats({
    Key? key,
    required this.appointments,
    required this.users,
  }) : super(key: key);

  DashboardStatistics _calculateStatistics() {
    final totalStudents =
        users.where((user) => user.role == RoleType.student.field).length;

    final activeStudents = users.where((user) => user.active == true).length;

    final todaysAppointments =
        DashboardUtils.getTodaysAppointments(appointments).length;

    final completedAppointments = appointments
        .where((appointment) => appointment.status == StatusType.completed)
        .length;

    return DashboardStatistics(
      totalStudents: totalStudents,
      activeStudents: activeStudents,
      todaysAppointments: todaysAppointments,
      completedAppointments: completedAppointments,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final statistics = _calculateStatistics();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _buildStatCard(
          context: context,
          icon: Icons.people,
          iconColor: colors.secondary,
          title: 'Total Students',
          value: statistics.totalStudents.toString(),
          backgroundColor: colors.white,
          onTap: () => _handleStatCardTap('Total Students'),
        ),
        _buildStatCard(
          context: context,
          icon: Icons.verified_outlined,
          iconColor: colors.primary.withOpacity(0.8),
          title: 'Active Students',
          value: statistics.activeStudents.toString(),
          backgroundColor: colors.white,
          onTap: () => _handleStatCardTap('Active Students'),
        ),
        _buildStatCard(
          context: context,
          icon: Icons.calendar_today,
          iconColor: colors.textPrimary,
          title: "Today's Appointments",
          value: statistics.todaysAppointments.toString(),
          backgroundColor: colors.white,
          onTap: () => _handleStatCardTap('Today\'s Appointments'),
        ),
        _buildStatCard(
          context: context,
          icon: Icons.check_circle_outline,
          iconColor: colors.primary,
          title: 'Completed Appointments',
          value: statistics.completedAppointments.toString(),
          backgroundColor: colors.white,
          onTap: () => _handleStatCardTap('Completed Appointments'),
        ),
      ],
    );
  }

  void _handleStatCardTap(String cardType) {
    // implements in the future
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    final boxShadow = context.shadows;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [boxShadow.light],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colors.black,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardStatistics {
  final int totalStudents;
  final int activeStudents;
  final int todaysAppointments;
  final int completedAppointments;

  const DashboardStatistics({
    required this.totalStudents,
    required this.activeStudents,
    required this.todaysAppointments,
    required this.completedAppointments,
  });
}
