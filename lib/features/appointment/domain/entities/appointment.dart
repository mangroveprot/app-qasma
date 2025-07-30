import 'package:equatable/equatable.dart';
import 'qrcode.dart';

import 'cancellation.dart';

class Appointment extends Equatable {
  final String studentId;
  final DateTime scheduledStartAt;
  final DateTime scheduledEndAt;
  final String appointmentCategory;
  final String appointmentType;
  final String description;
  final String status;
  final String checkInStatus;
  final QRCode qrCode;
  final Cancellation cancellation;
  final DateTime? deletedAt;
  final String? deletedBy;
  final String createdBy;
  final String? updatedBy;
  final int version;
  final String appointmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.studentId,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
    required this.appointmentCategory,
    required this.appointmentType,
    required this.description,
    required this.status,
    required this.checkInStatus,
    required this.qrCode,
    required this.cancellation,
    this.deletedAt,
    this.deletedBy,
    required this.createdBy,
    this.updatedBy,
    required this.version,
    required this.appointmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper methods
  bool get isDeleted => deletedAt != null;
  bool get isPending => status == 'pending';
  bool get isCancelled => cancellation.cancelledAt != null;
  bool get isCheckedIn => checkInStatus != 'not-checked-in';
  bool get isOnline => appointmentType == 'Online';
  bool get isPsychological => appointmentCategory == 'Psychological';

  Duration get duration => scheduledEndAt.difference(scheduledStartAt);

  bool get isUpcoming {
    final now = DateTime.now();
    return scheduledStartAt.isAfter(now) && !isCancelled && !isDeleted;
  }

  @override
  List<Object?> get props => [
        studentId,
        scheduledStartAt,
        scheduledEndAt,
        appointmentCategory,
        appointmentType,
        description,
        status,
        checkInStatus,
        qrCode,
        cancellation,
        deletedAt,
        deletedBy,
        createdBy,
        updatedBy,
        version,
        appointmentId,
        createdAt,
        updatedAt,
      ];
}
