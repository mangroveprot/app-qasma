import 'package:equatable/equatable.dart';

class Reschedule extends Equatable {
  final String? rescheduledBy;
  final String? remarks;
  final DateTime? rescheduledAt;
  final DateTime? previousStart;
  final DateTime? previousEnd;

  const Reschedule({
    this.rescheduledBy,
    this.remarks,
    this.rescheduledAt,
    this.previousStart,
    this.previousEnd,
  });

  factory Reschedule.fromMap(Map<String, dynamic> map) {
    return Reschedule(
      rescheduledBy: map['rescheduledBy'],
      remarks: map['remarks'],
      rescheduledAt: map['rescheduledAt'] != null
          ? DateTime.parse(map['rescheduledAt'])
          : null,
      previousStart: map['previousStart'] != null
          ? DateTime.parse(map['previousStart'])
          : null,
      previousEnd: map['previousEnd'] != null
          ? DateTime.parse(map['previousEnd'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rescheduledBy': rescheduledBy,
      'remarks': remarks,
      'rescheduledAt': rescheduledAt?.toIso8601String(),
      'previousStart': previousStart?.toIso8601String(),
      'previousEnd': previousEnd?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [rescheduledBy, remarks, rescheduledAt, previousStart, previousEnd];
}
