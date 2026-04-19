import 'package:equatable/equatable.dart';

import '../config/activity_logs_config.dart';

/// Filter model for Activity Logs page (Preferences).
///
/// - `status`: category filter (all/account/appointment/security/system)
/// - `dateFrom` / `dateTo`: inclusive date range based on `createdAt`
/// - `role`: 'all', 'student', 'counselor', 'staff'
class ActivityLogsFilterModel extends Equatable {
  final ActivityLogFilterStatus status;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String role;

  const ActivityLogsFilterModel({
    this.status = ActivityLogFilterStatus.all,
    this.dateFrom,
    this.dateTo,
    this.role = 'all',
  });

  ActivityLogsFilterModel copyWith({
    ActivityLogFilterStatus? status,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? role,
  }) {
    return ActivityLogsFilterModel(
      status: status ?? this.status,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      role: role ?? this.role,
    );
  }

  int get activeFilterCount {
    int count = 0;
    if (status != ActivityLogFilterStatus.all) count++;
    if (dateFrom != null || dateTo != null) count++;
    if (role.toLowerCase() != 'all') count++;
    return count;
  }

  bool get hasActiveFilters => activeFilterCount > 0;

  ActivityLogsFilterModel reset() {
    return const ActivityLogsFilterModel();
  }

  ActivityLogsFilterModel resetStatus() {
    return copyWith(status: ActivityLogFilterStatus.all);
  }

  ActivityLogsFilterModel resetDate() {
    return copyWith(dateFrom: null, dateTo: null);
  }

  ActivityLogsFilterModel resetRole() {
    return copyWith(role: 'all');
  }

  @override
  List<Object?> get props => [status, dateFrom, dateTo, role];
}


