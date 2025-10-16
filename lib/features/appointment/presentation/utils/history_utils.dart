import 'package:flutter/material.dart';

import '../../../../common/helpers/helpers.dart';
import '../../../../common/helpers/spacing.dart';
import '../../../../common/utils/constant.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../users/data/models/user_model.dart';
import '../../data/models/appointment_model.dart';
import '../widgets/history_widget/history_modal_section.dart';
import '../widgets/history_widget/info_section.dart';

enum AppointmentHistoryStatus { all, cancelled, completed }

extension AppointmentHistoryStatusExtension on AppointmentHistoryStatus {
  String get displayName {
    switch (this) {
      case AppointmentHistoryStatus.all:
        return 'All';
      case AppointmentHistoryStatus.cancelled:
        return 'Cancelled';
      case AppointmentHistoryStatus.completed:
        return 'Completed';
    }
  }
}

class HistoryUtils {
  static String get currId => SharedPrefs().getString('currentUserId') ?? '';

  static void show(
    BuildContext context,
    AppointmentModel appointment,
    List<UserModel>? users,
  ) {
    HistoryModalSection.show(
      context,
      title: 'Appointment Details',
      child: Column(
        children: [
          InfoSection(
            title: 'Appointment Information',
            icon: Icons.event_note_outlined,
            items: _getAppointmentInfo(appointment),
          ),
          Spacing.verticalMedium,
          InfoSection(
            title: 'Approval Information',
            icon: Icons.verified_outlined,
            items: _getApprovalInfo(appointment, users),
          ),
          if (appointment.status == StatusType.completed.field) ...[
            Spacing.verticalMedium,
            InfoSection(
              title: 'Check-in Information',
              icon: Icons.check_circle_outline,
              items: _getCheckInInfo(appointment, users),
            ),
          ],
          if (appointment.status == StatusType.cancelled.field) ...[
            Spacing.verticalMedium,
            InfoSection(
              title: 'Cancellation Information',
              icon: Icons.cancel_outlined,
              items: _getCancellationInfo(appointment, users),
            )
          ],
          Spacing.verticalLarge,
        ],
      ),
    );
  }

  static Map<String, String> _getAppointmentInfo(
    AppointmentModel appointment,
  ) {
    return {
      'Category':
          capitalizeWords(_safe(appointment.appointmentCategory.toString())),
      'Type': _safe(appointment.appointmentType.toString()),
      'Status': capitalizeWords(_safe(appointment.status.toString())),
      'Date': _safeDate(
        appointment.scheduledStartAt.toString(),
        DateTimeFormatStyle.dateOnly,
      ),
      'Start Time': _safeDate(
        appointment.scheduledStartAt.toString(),
        DateTimeFormatStyle.timeOnly,
      ),
      'End Time': _safeDate(
        appointment.scheduledEndAt.toString(),
        DateTimeFormatStyle.timeOnly,
      ),
    };
  }

  static Map<String, String> _getApprovalInfo(
    AppointmentModel appointment,
    List<UserModel>? users,
  ) {
    final staff = _findUser(
      users,
      predicate: (u) => u.idNumber == appointment.staffId,
    );
    final counselor = _findUser(
      users,
      predicate: (u) => u.idNumber == appointment.counselorId,
    );

    return {
      'Approved By Staff': capitalizeWords(_safe(staff?.fullName)),
      'Assigned Counselor': _safe(counselor?.fullName),
    };
  }

  static Map<String, String> _getCheckInInfo(
    AppointmentModel appointment,
    List<UserModel>? users,
  ) {
    final counselor = _findUser(
      users,
      predicate: (u) => u.idNumber == appointment.qrCode.scannedById,
    );

    return {
      'Check-in-status': _safe(appointment.checkInStatus.toString()),
      'Check-in-at': _safeDate(
        appointment.checkInTime?.toString(),
        DateTimeFormatStyle.dateAndTime,
      ),
      'Scanned By': _safe(counselor?.fullName),
      'Scanned At': _safeDate(
        appointment.qrCode.scannedAt?.toString(),
        DateTimeFormatStyle.dateAndTime,
      ),
    };
  }

  static Map<String, String> _getCancellationInfo(
    AppointmentModel appointment,
    List<UserModel>? users,
  ) {
    final isCurrentUser = appointment.cancellation.cancelledById == currId;
    final user = _findUser(
      users,
      predicate: (u) => u.idNumber == appointment.cancellation.cancelledById,
    );

    return {
      'Reason': _safe(appointment.cancellation.reason?.toString()),
      'Cancelled At': _safeDate(
        appointment.cancellation.cancelledAt?.toString(),
        DateTimeFormatStyle.dateAndTime,
      ),
      'Cancelled By': _safe(
        isCurrentUser
            ? 'Me'
            : '${user?.fullName ?? 'Unknown'} - ${user?.role ?? 'Uknown Role'}',
      ),
    };
  }

  static String _safe(String? value) =>
      value?.isNotEmpty == true ? value! : 'N/A';

  static String _safeDate(String? dateString, DateTimeFormatStyle style) {
    if (dateString?.isNotEmpty != true) return 'N/A';
    try {
      return formatUtcToLocal(utcTime: dateString!, style: style);
    } catch (e) {
      return 'N/A';
    }
  }

  static UserModel? _findUser(
    List<UserModel>? users, {
    required bool Function(UserModel) predicate,
  }) {
    if (users == null || users.isEmpty) {
      return null;
    }

    try {
      return users.firstWhere(predicate);
    } catch (e) {
      return null;
    }
  }
}
