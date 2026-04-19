import 'package:equatable/equatable.dart';

class HomeAppointmentFilterModel extends Equatable {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String sortBy; // 'newest', 'oldest'
  final String overdue; // 'all', 'overdue', 'not_overdue'

  const HomeAppointmentFilterModel({
    this.dateFrom,
    this.dateTo,
    this.sortBy = 'newest',
    this.overdue = 'all',
  });

  HomeAppointmentFilterModel copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? sortBy,
    String? overdue,
  }) {
    return HomeAppointmentFilterModel(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      sortBy: sortBy ?? this.sortBy,
      overdue: overdue ?? this.overdue,
    );
  }

  int get activeFilterCount {
    int count = 0;
    if (dateFrom != null || dateTo != null) count++;
    if (sortBy == 'oldest') count++;
    if (overdue != 'all') count++;
    return count;
  }

  bool get hasActiveFilters => activeFilterCount > 0;

  HomeAppointmentFilterModel reset() => const HomeAppointmentFilterModel();

  HomeAppointmentFilterModel resetDate() => copyWith(dateFrom: null, dateTo: null);

  HomeAppointmentFilterModel resetSort() => copyWith(sortBy: 'newest');

  HomeAppointmentFilterModel resetOverdue() => copyWith(overdue: 'all');

  @override
  List<Object?> get props => [dateFrom, dateTo, sortBy, overdue];
}

