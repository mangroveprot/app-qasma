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
