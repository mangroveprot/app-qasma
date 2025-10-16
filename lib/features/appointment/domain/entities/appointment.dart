import 'package:equatable/equatable.dart';
import 'qrcode.dart';

import 'cancellation.dart';
import 'reschedule.dart';

class Appointment extends Equatable {
  final String studentId;
  final DateTime scheduledStartAt;
  final DateTime scheduledEndAt;
  final String appointmentCategory;
  final String appointmentType;
  final String description;
  final String status;
  final String? checkInStatus;
  final DateTime? checkInTime;
  final String? staffId;
  final String? counselorId;
  final bool feedbackSubmitted;
  final QRCode qrCode;
  final Cancellation cancellation;
  final Reschedule reschedule;
  final DateTime? deletedAt;
  final String? deletedBy;
  final String createdBy;
  final String? updatedBy;
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
    this.checkInTime,
    this.checkInStatus,
    this.staffId,
    this.counselorId,
    required this.feedbackSubmitted,
    required this.qrCode,
    required this.cancellation,
    required this.reschedule,
    this.deletedAt,
    this.deletedBy,
    required this.createdBy,
    this.updatedBy,
    required this.appointmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isDeleted => deletedAt != null;
  bool get isCancelled => cancellation.cancelledAt != null;

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
        checkInTime,
        staffId,
        counselorId,
        feedbackSubmitted,
        qrCode,
        cancellation,
        reschedule,
        deletedAt,
        deletedBy,
        createdBy,
        updatedBy,
        appointmentId,
        createdAt,
        updatedAt,
      ];
}
