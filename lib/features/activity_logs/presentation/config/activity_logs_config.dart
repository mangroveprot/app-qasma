import 'package:flutter/material.dart';

import '../../../../common/utils/constant.dart';
import '../../domain/entities/activity_log.dart';

enum ActivityLogFilterStatus {
  all,
  account,
  appointment,
  security,
  system,
}

class CategoryMeta {
  final Color iconColor;
  final Color iconBg;
  final IconData icon;
  final String label;

  const CategoryMeta({
    required this.iconColor,
    required this.iconBg,
    required this.icon,
    required this.label,
  });
}

const Map<ActivityCategory, CategoryMeta> activityCategoryMeta = {
  ActivityCategory.account: CategoryMeta(
    iconColor: Color(0xFF4A7C59),
    iconBg: Color(0xFFF0F7F2),
    icon: Icons.person_outline_rounded,
    label: 'Account',
  ),
  ActivityCategory.appointment: CategoryMeta(
    iconColor: Color(0xFF4A6FA5),
    iconBg: Color(0xFFF0F4FA),
    icon: Icons.calendar_today_outlined,
    label: 'Appointment',
  ),
  ActivityCategory.security: CategoryMeta(
    iconColor: Color(0xFF8B5E5E),
    iconBg: Color(0xFFF9F2F2),
    icon: Icons.shield_outlined,
    label: 'Security',
  ),
  ActivityCategory.system: CategoryMeta(
    iconColor: Color(0xFF7A6E8A),
    iconBg: Color(0xFFF5F3F8),
    icon: Icons.settings_outlined,
    label: 'System',
  ),
};

List<String> excludedActivityLogRoles = [RoleType.counselor.field];
