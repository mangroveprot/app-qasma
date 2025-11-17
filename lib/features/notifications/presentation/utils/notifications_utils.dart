import 'package:flutter/material.dart';

import '../../../../common/utils/constant.dart';

class NotificationsUtils {
  static Map<String, dynamic> getNotificationConfig(String type) {
    final upperType = type.toUpperCase();

    if (upperType == NotificationType.appointmentRescheduled.field) {
      return {
        'icon': Icons.schedule,
        'bgColor': const Color(0xFFFEF3C7),
        'iconColor': const Color(0xFFD97706),
      };
    } else if (upperType == NotificationType.appointmentConfirmed.field) {
      return {
        'icon': Icons.check_circle,
        'bgColor': const Color(0xFFD1FAE5),
        'iconColor': const Color(0xFF059669),
      };
    } else if (upperType == NotificationType.appointmentCancelled.field) {
      return {
        'icon': Icons.close,
        'bgColor': const Color(0xFFFEE2E2),
        'iconColor': const Color(0xFFDC2626),
      };
    } else if (upperType == NotificationType.appointmentCompleted.field) {
      return {
        'icon': Icons.check_circle_outline,
        'bgColor': const Color(0xFFDCFCE7),
        'iconColor': const Color(0xFF16A34A),
      };
    } else if (upperType == NotificationType.checkInReminder.field) {
      return {
        'icon': Icons.alarm,
        'bgColor': const Color(0xFFDDD6FE),
        'iconColor': const Color(0xFF7C3AED),
      };
    } else {
      return {
        'icon': Icons.notifications,
        'bgColor': const Color(0xFFF3F4F6),
        'iconColor': const Color(0xFF6B7280),
      };
    }
  }

  static String? getAdditionalInfo(String type, Map<String, dynamic> data) {
    final upperType = type.toUpperCase();

    if (upperType == NotificationType.appointmentRescheduled.field) {
      return data['remarks'] as String?;
    }

    if (upperType == NotificationType.appointmentCancelled.field) {
      return data['reason'] as String?;
    }

    return null;
  }

  static String getTimeAgo(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
