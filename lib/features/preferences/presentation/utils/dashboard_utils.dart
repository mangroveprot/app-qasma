import 'package:flutter/material.dart';

import '../../../../common/data/model/master_list_model.dart';
import '../../../../common/helpers/helpers.dart';
import '../../../../common/utils/constant.dart';
import '../../../../infrastructure/theme/theme_extensions.dart';
import '../../../appointment/data/models/appointment_model.dart';
import '../../../users/data/models/user_model.dart';
import '../config/appointment_stats_data.dart';

class DashboardUtils {
  static int countStatus({
    required List<AppointmentModel> appointments,
    required String status,
  }) {
    final filter = appointments
        .where((appointment) => appointment.status.toLowerCase() == status);

    return filter.length;
  }

  static List<T> filter<T>({
    required List<T> items,
    required bool Function(T) predicate,
  }) {
    return items.where(predicate).toList();
  }

  static List<AppointmentModel> getRecentAppointments({
    required List<AppointmentModel> appointments,
    int limit = 5,
  }) {
    appointments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return appointments.take(limit).toList();
  }

  static List<AppointmentModel> getTodaysAppointments(
      List<AppointmentModel> appointments) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return appointments.where((appointment) {
      final start = appointment.scheduledStartAt;
      final appointmentDate = DateTime(start.year, start.month, start.day);
      return appointmentDate == today;
    }).toList();
  }

  static List<AppointmentStatsData> apppointmentStatsData({
    required List<AppointmentModel> appointments,
    required BuildContext context,
  }) {
    final colors = context.colors;

    final int totalAppointments = appointments.length;

    final int _countPending = countStatus(
      appointments: appointments,
      status: StatusType.pending.field,
    );
    final int _countApproved = countStatus(
      appointments: appointments,
      status: StatusType.approved.field,
    );
    final int _countCompleted = countStatus(
      appointments: appointments,
      status: StatusType.completed.field,
    );
    final int _countCancelled = countStatus(
      appointments: appointments,
      status: StatusType.cancelled.field,
    );

    final List<AppointmentStatsData> data = [
      AppointmentStatsData(
        label: capitalizeWords(StatusType.pending.field),
        count: _countPending,
        percentage: totalAppointments > 0
            ? (_countPending / totalAppointments * 100).round()
            : 0,
        color: colors.warning,
        icon: Icons.access_time,
      ),
      AppointmentStatsData(
        label: capitalizeWords(StatusType.approved.field),
        count: _countApproved,
        percentage: totalAppointments > 0
            ? (_countApproved / totalAppointments * 100).round()
            : 0,
        color: colors.primary.withOpacity(0.5),
        icon: Icons.check_circle_outline,
      ),
      AppointmentStatsData(
        label: capitalizeWords(StatusType.completed.field),
        count: _countCompleted,
        percentage: totalAppointments > 0
            ? (_countCompleted / totalAppointments * 100).round()
            : 0,
        color: colors.primary,
        icon: Icons.check,
      ),
      AppointmentStatsData(
        label: capitalizeWords(StatusType.cancelled.field),
        count: _countCancelled,
        percentage: totalAppointments > 0
            ? (_countCancelled / totalAppointments * 100).round()
            : 0,
        color: colors.error,
        icon: Icons.cancel_outlined,
      ),
    ];

    return data;
  }

  static List<MasterlistModel> masterListData({
    required List<AppointmentModel> appointments,
    required List<UserModel> users,
  }) {
    final List<AppointmentModel> completedAppointments =
        DashboardUtils.filter<AppointmentModel>(
      items: appointments,
      predicate: (appointment) =>
          appointment.status == StatusType.completed.field ||
          appointment.status == StatusType.cancelled.field,
    );

    final List<MasterlistModel> masterList = [];
    int i = 1;

    for (final appointment in completedAppointments) {
      try {
        final user = users.firstWhere(
          (user) => user.idNumber == appointment.studentId,
        );

        masterList.add(
          MasterlistModel(
            no: i.toString(),
            date: formatUtcToLocal(
              utcTime: appointment.scheduledStartAt.toString(),
              style: DateTimeFormatStyle.dateOnly,
            ),
            name: user.fullName,
            address: user.address,
            contactNo: user.contact_number,
            purpose: appointment.appointmentCategory,
            status: appointment.status,
          ),
        );

        i++;
      } catch (e) {
        continue;
      }
    }

    return masterList;
  }
}
