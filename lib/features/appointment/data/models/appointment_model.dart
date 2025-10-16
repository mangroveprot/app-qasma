import 'dart:convert';
import '../../../../common/utils/model_utils.dart';
import '../../domain/entities/appointment.dart';
import 'qrcode_model.dart';
import 'cancellation_model.dart';
import 'reschedule_model.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.studentId,
    required super.scheduledStartAt,
    required super.scheduledEndAt,
    required super.appointmentCategory,
    required super.appointmentType,
    required super.description,
    required super.status,
    required super.checkInStatus,
    super.checkInTime,
    super.staffId,
    super.counselorId,
    required super.feedbackSubmitted,
    required super.qrCode,
    required super.cancellation,
    required super.reschedule,
    super.deletedAt,
    super.deletedBy,
    required super.createdBy,
    super.updatedBy,
    required super.appointmentId,
    required super.createdAt,
    required super.updatedAt,
  });

  // to db (sqlite)
  Map<String, dynamic> toDb() {
    return {
      'studentId': studentId,
      'scheduledStartAt': scheduledStartAt.toIso8601String(),
      'scheduledEndAt': scheduledEndAt.toIso8601String(),
      'appointmentCategory': appointmentCategory,
      'appointmentType': appointmentType,
      'description': description,
      'status': status,
      'checkInStatus': checkInStatus,
      'checkInTime': checkInTime?.toIso8601String(),
      'staffId': staffId,
      'counselorId': counselorId,
      'feedbackSubmitted': feedbackSubmitted ? 1 : 0,
      'qrCode': jsonEncode(qrCode.toMap()),
      'cancellation': jsonEncode(cancellation.toMap()),
      'reschedule': jsonEncode(reschedule.toMap()),
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'appointmentId': appointmentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // from localdb (sqlite)
  factory AppointmentModel.fromDb(Map<String, dynamic> map) {
    return AppointmentModel(
      studentId: ModelUtils.getString(map, 'studentId'),
      scheduledStartAt: ModelUtils.getDateTime(map, 'scheduledStartAt'),
      scheduledEndAt: ModelUtils.getDateTime(map, 'scheduledEndAt'),
      appointmentCategory: ModelUtils.getString(map, 'appointmentCategory'),
      appointmentType: ModelUtils.getString(map, 'appointmentType'),
      description: ModelUtils.getString(map, 'description'),
      status: ModelUtils.getString(map, 'status'),
      checkInStatus: ModelUtils.getString(map, 'checkInStatus'),
      checkInTime: ModelUtils.getNullableDateTime(map, 'checkInTime'),
      staffId: ModelUtils.getString(map, 'staffId'),
      counselorId: ModelUtils.getString(map, 'counselorId'),
      feedbackSubmitted: ModelUtils.getBool(map, 'feedbackSubmitted'),
      qrCode: QRCodeModel.fromMap(
        map['qrCode'] != null ? jsonDecode(map['qrCode']) : <String, dynamic>{},
      ),
      cancellation: CancellationModel.fromMap(
        map['cancellation'] != null
            ? jsonDecode(map['cancellation'])
            : <String, dynamic>{},
      ),
      reschedule: RescheduleModel.fromMap(
        map['reschedule'] != null
            ? jsonDecode(map['reschedule'])
            : <String, dynamic>{},
      ),
      deletedAt: ModelUtils.getNullableDateTime(map, 'deletedAt'),
      deletedBy: ModelUtils.getString(map, 'deletedBy'),
      createdBy: ModelUtils.getString(map, 'createdBy'),
      updatedBy: ModelUtils.getString(map, 'updatedBy'),
      appointmentId: ModelUtils.getString(map, 'appointmentId'),
      createdAt: ModelUtils.getDateTime(map, 'createdAt'),
      updatedAt: ModelUtils.getDateTime(map, 'updatedAt'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'scheduledStartAt': scheduledStartAt.toIso8601String(),
      'scheduledEndAt': scheduledEndAt.toIso8601String(),
      'appointmentCategory': appointmentCategory,
      'appointmentType': appointmentType,
      'description': description,
      'status': status,
      'checkInStatus': checkInStatus,
      'checkInTime': checkInTime?.toIso8601String(),
      'staffId': staffId,
      'counselorId': counselorId,
      'feedbackSubmitted': feedbackSubmitted,
      'qrCode': qrCode.toMap(),
      'cancellation': cancellation.toMap(),
      'appointmentId': appointmentId,
    };
  }

  Map<String, dynamic> createAppointmentToJson() {
    return {
      'studentId': studentId,
      'scheduledStartAt': scheduledStartAt.toIso8601String(),
      'scheduledEndAt': scheduledEndAt.toIso8601String(),
      'appointmentType': appointmentType,
      'appointmentCategory': appointmentCategory,
      'description': description,
    };
  }

  Map<String, dynamic> updateAppointmentToJson() {
    return {
      'studentId': studentId,
      'appointmentId': appointmentId,
      'scheduledStartAt': scheduledStartAt.toIso8601String(),
      'scheduledEndAt': scheduledEndAt.toIso8601String(),
      'appointmentType': appointmentType,
      'appointmentCategory': appointmentCategory,
      'description': description,
      'feedbackSubmitted': feedbackSubmitted,
      'reschedule': reschedule.toMap(),
    };
  }

  // From API (JSON format) - handles both camelCase and snake_case
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      studentId: ModelUtils.getString(json, 'studentId', 'student_id'),
      scheduledStartAt: ModelUtils.getDateTime(
          json, 'scheduledStartAt', 'scheduled_start_at'),
      scheduledEndAt:
          ModelUtils.getDateTime(json, 'scheduledEndAt', 'scheduled_end_at'),
      appointmentCategory: ModelUtils.getString(
          json, 'appointmentCategory', 'appointment_category'),
      appointmentType:
          ModelUtils.getString(json, 'appointmentType', 'appointment_type'),
      description: ModelUtils.getString(json, 'description'),
      status: ModelUtils.getString(json, 'status'),
      checkInStatus:
          ModelUtils.getString(json, 'checkInStatus', 'check_in_status'),
      checkInTime:
          ModelUtils.getNullableDateTime(json, 'checkInTime', 'check_in_time'),
      staffId: ModelUtils.getString(json, 'staffId', 'staff_id'),
      counselorId: ModelUtils.getString(json, 'counselorId', 'counselor_id'),
      feedbackSubmitted: ModelUtils.getBool(json, 'feedbackSubmitted'),
      qrCode: QRCodeModel.fromMap(
        json['qrCode'] ?? json['qr_code'] ?? <String, dynamic>{},
      ),
      cancellation: CancellationModel.fromMap(
        json['cancellation'] ?? <String, dynamic>{},
      ),
      reschedule: RescheduleModel.fromMap(
        json['reschedule'] ?? <String, dynamic>{},
      ),
      deletedAt:
          ModelUtils.getNullableDateTime(json, 'deletedAt', 'deleted_at'),
      deletedBy: ModelUtils.getString(json, 'deletedBy', 'deleted_by'),
      createdBy: ModelUtils.getString(json, 'createdBy', 'created_by'),
      updatedBy: ModelUtils.getString(json, 'updatedBy', 'updated_by'),
      appointmentId:
          ModelUtils.getString(json, 'appointmentId', 'appointment_id'),
      createdAt: ModelUtils.getDateTime(json, 'createdAt', 'created_at'),
      updatedAt: ModelUtils.getDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  // Convert to entity
  Appointment toEntity() {
    return Appointment(
      studentId: studentId,
      scheduledStartAt: scheduledStartAt,
      scheduledEndAt: scheduledEndAt,
      appointmentCategory: appointmentCategory,
      appointmentType: appointmentType,
      description: description,
      status: status,
      checkInStatus: checkInStatus,
      checkInTime: checkInTime,
      staffId: staffId,
      counselorId: counselorId,
      feedbackSubmitted: feedbackSubmitted,
      qrCode: qrCode,
      cancellation: cancellation,
      reschedule: reschedule,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
      createdBy: createdBy,
      updatedBy: updatedBy,
      appointmentId: appointmentId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Create from entity
  factory AppointmentModel.fromEntity(Appointment entity) {
    return AppointmentModel(
      studentId: entity.studentId,
      scheduledStartAt: entity.scheduledStartAt,
      scheduledEndAt: entity.scheduledEndAt,
      appointmentCategory: entity.appointmentCategory,
      appointmentType: entity.appointmentType,
      description: entity.description,
      status: entity.status,
      checkInStatus: entity.checkInStatus,
      checkInTime: entity.checkInTime,
      staffId: entity.staffId,
      counselorId: entity.counselorId,
      feedbackSubmitted: entity.feedbackSubmitted,
      qrCode: QRCodeModel.fromEntity(entity.qrCode),
      cancellation: CancellationModel.fromEntity(entity.cancellation),
      reschedule: RescheduleModel.fromEntity(entity.reschedule),
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      appointmentId: entity.appointmentId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
