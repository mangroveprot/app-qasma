import 'package:equatable/equatable.dart';

class AppointmentFilterModel extends Equatable {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String status; // 'all', 'pending', 'approved', 'completed', 'cancelled'
  final String purpose;
  final String sortBy; // 'newest', 'oldest'

  const AppointmentFilterModel({
    this.dateFrom,
    this.dateTo,
    this.status = 'all',
    this.purpose = 'all',
    this.sortBy = 'newest',
  });

  AppointmentFilterModel copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? status,
    String? purpose,
    String? sortBy,
  }) {
    return AppointmentFilterModel(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      status: status ?? this.status,
      purpose: purpose ?? this.purpose,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  int get activeFilterCount {
    int count = 0;
    if (dateFrom != null || dateTo != null) count++;
    if (status != 'all') count++;
    if (purpose != 'all') count++;
    if (sortBy == 'oldest') count++;
    return count;
  }

  bool get hasActiveFilters => activeFilterCount > 0;

  AppointmentFilterModel reset() {
    return const AppointmentFilterModel();
  }

  AppointmentFilterModel resetDate() {
    return copyWith(dateFrom: null, dateTo: null);
  }

  AppointmentFilterModel resetStatus() {
    return copyWith(status: 'all');
  }

  AppointmentFilterModel resetPurpose() {
    return copyWith(purpose: 'all');
  }

  AppointmentFilterModel resetSort() {
    return copyWith(sortBy: 'newest');
  }

  @override
  List<Object?> get props => [dateFrom, dateTo, status, purpose, sortBy];
}
