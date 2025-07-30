import 'dart:convert';
import '../../domain/entities/appointment.dart';
import 'qrcode_model.dart';
import 'cancellation_model.dart';

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
    required super.qrCode,
    required super.cancellation,
    super.deletedAt,
    super.deletedBy,
    required super.createdBy,
    super.updatedBy,
    required super.version,
    required super.appointmentId,
    required super.createdAt,
    required super.updatedAt,
  });

  // helpers for value safety
  static String _getString(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    return map[key1]?.toString() ?? map[key2]?.toString() ?? '';
  }

  static int _getInt(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime _getDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1]?.toString() ?? map[key2]?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  static DateTime? _getNullableDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final raw = map.containsKey(key1)
        ? map[key1]
        : (key2 != null && map.containsKey(key2) ? map[key2] : null);
    final value = raw?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

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
      'qrCode': jsonEncode(qrCode.toMap()),
      'cancellation': jsonEncode(cancellation.toMap()),
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'version': version,
      'appointmentId': appointmentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // from localdb (sqlite)
  factory AppointmentModel.fromDb(Map<String, dynamic> map) {
    return AppointmentModel(
      studentId: _getString(map, 'studentId'),
      scheduledStartAt: _getDateTime(map, 'scheduledStartAt'),
      scheduledEndAt: _getDateTime(map, 'scheduledEndAt'),
      appointmentCategory: _getString(map, 'appointmentCategory'),
      appointmentType: _getString(map, 'appointmentType'),
      description: _getString(map, 'description'),
      status: _getString(map, 'status'),
      checkInStatus: _getString(map, 'checkInStatus'),
      qrCode: QRCodeModel.fromMap(
        map['qrCode'] != null ? jsonDecode(map['qrCode']) : <String, dynamic>{},
      ),
      cancellation: CancellationModel.fromMap(
        map['cancellation'] != null
            ? jsonDecode(map['cancellation'])
            : <String, dynamic>{},
      ),
      deletedAt: _getNullableDateTime(map, 'deletedAt'),
      deletedBy: _getString(map, 'deletedBy'),
      createdBy: _getString(map, 'createdBy'),
      updatedBy: _getString(map, 'updatedBy'),
      version: _getInt(map, 'version'),
      appointmentId: _getString(map, 'appointmentId'),
      createdAt: _getDateTime(map, 'createdAt'),
      updatedAt: _getDateTime(map, 'updatedAt'),
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
      'qrCode': qrCode.toMap(),
      'cancellation': cancellation.toMap(),
      'appointmentId': appointmentId,
    };
  }

  // From API (JSON format) - handles both camelCase and snake_case
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      studentId: _getString(json, 'studentId', 'student_id'),
      scheduledStartAt:
          _getDateTime(json, 'scheduledStartAt', 'scheduled_start_at'),
      scheduledEndAt: _getDateTime(json, 'scheduledEndAt', 'scheduled_end_at'),
      appointmentCategory:
          _getString(json, 'appointmentCategory', 'appointment_category'),
      appointmentType: _getString(json, 'appointmentType', 'appointment_type'),
      description: _getString(json, 'description'),
      status: _getString(json, 'status'),
      checkInStatus: _getString(json, 'checkInStatus', 'check_in_status'),
      qrCode: QRCodeModel.fromMap(
        json['qrCode'] ?? json['qr_code'] ?? <String, dynamic>{},
      ),
      cancellation: CancellationModel.fromMap(
        json['cancellation'] ?? <String, dynamic>{},
      ),
      deletedAt: _getNullableDateTime(json, 'deletedAt', 'deleted_at'),
      deletedBy: _getString(json, 'deletedBy', 'deleted_by'),
      createdBy: _getString(json, 'createdBy', 'created_by'),
      updatedBy: _getString(json, 'updatedBy', 'updated_by'),
      version: _getInt(json, '__version__'),
      appointmentId: _getString(json, 'appointmentId', 'appointment_id'),
      createdAt: _getDateTime(json, 'createdAt', 'created_at'),
      updatedAt: _getDateTime(json, 'updatedAt', 'updated_at'),
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
      qrCode: qrCode,
      cancellation: cancellation,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
      createdBy: createdBy,
      updatedBy: updatedBy,
      version: version,
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
      qrCode: QRCodeModel.fromEntity(entity.qrCode),
      cancellation: CancellationModel.fromEntity(entity.cancellation),
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      version: entity.version,
      appointmentId: entity.appointmentId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
