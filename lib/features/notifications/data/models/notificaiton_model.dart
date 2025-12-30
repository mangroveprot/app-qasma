import 'dart:convert';
import '../../../../common/utils/model_utils.dart';
import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.notificationId,
    required super.userId,
    required super.type,
    required super.title,
    required super.body,
    required super.data,
    required super.status,
    super.sentAt,
    super.readAt,
    super.fcmResponse,
    super.deletedAt,
    super.deletedBy,
    required super.createdAt,
    required super.updatedAt,
  });

  // To SQLite database
  Map<String, dynamic> toDb() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': jsonEncode(data),
      'status': status,
      'sentAt': sentAt?.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'fcmResponse': fcmResponse != null ? jsonEncode(fcmResponse) : null,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // From SQLite database
  factory NotificationModel.fromDb(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: ModelUtils.getString(map, 'notificationId'),
      userId: ModelUtils.getString(map, 'userId'),
      type: ModelUtils.getString(map, 'type'),
      title: ModelUtils.getString(map, 'title'),
      body: ModelUtils.getString(map, 'body'),
      data: map['data'] != null
          ? jsonDecode(map['data']) as Map<String, dynamic>
          : {},
      status: ModelUtils.getString(map, 'status'),
      sentAt: ModelUtils.getNullableDateTime(map, 'sentAt'),
      readAt: ModelUtils.getNullableDateTime(map, 'readAt'),
      fcmResponse: map['fcmResponse'] != null
          ? jsonDecode(map['fcmResponse']) as Map<String, dynamic>
          : null,
      deletedAt: ModelUtils.getNullableDateTime(map, 'deletedAt'),
      deletedBy: ModelUtils.getString(map, 'deletedBy'),
      createdAt: ModelUtils.getDateTime(map, 'createdAt'),
      updatedAt: ModelUtils.getDateTime(map, 'updatedAt'),
    );
  }

  // To JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'status': status,
      'sentAt': sentAt?.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'fcmResponse': fcmResponse,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // From JSON (from API) - handles both camelCase and snake_case
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: ModelUtils.getString(
        json,
        'notificationId',
        'notification_id',
      ),
      userId: ModelUtils.getString(json, 'userId', 'user_id'),
      type: ModelUtils.getString(json, 'type'),
      title: ModelUtils.getString(json, 'title'),
      body: ModelUtils.getString(json, 'body'),
      data: json['data'] as Map<String, dynamic>? ?? {},
      status: ModelUtils.getString(json, 'status'),
      sentAt: ModelUtils.getNullableDateTime(json, 'sentAt', 'sent_at'),
      readAt: ModelUtils.getNullableDateTime(json, 'readAt', 'read_at'),
      fcmResponse: json['fcmResponse'] as Map<String, dynamic>? ??
          json['fcm_response'] as Map<String, dynamic>?,
      deletedAt:
          ModelUtils.getNullableDateTime(json, 'deletedAt', 'deleted_at'),
      deletedBy: ModelUtils.getString(json, 'deletedBy', 'deleted_by'),
      createdAt: ModelUtils.getDateTime(json, 'createdAt', 'created_at'),
      updatedAt: ModelUtils.getDateTime(json, 'updatedAt', 'updated_at'),
    );
  }

  // Convert to entity
  Notification toEntity() {
    return Notification(
      notificationId: notificationId,
      userId: userId,
      type: type,
      title: title,
      body: body,
      data: data,
      status: status,
      sentAt: sentAt,
      readAt: readAt,
      fcmResponse: fcmResponse,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Create from entity
  factory NotificationModel.fromEntity(Notification entity) {
    return NotificationModel(
      notificationId: entity.notificationId,
      userId: entity.userId,
      type: entity.type,
      title: entity.title,
      body: entity.body,
      data: entity.data,
      status: entity.status,
      sentAt: entity.sentAt,
      readAt: entity.readAt,
      fcmResponse: entity.fcmResponse,
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Copy with
  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? status,
    DateTime? sentAt,
    DateTime? readAt,
    Map<String, dynamic>? fcmResponse,
    String? deletedBy,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      fcmResponse: fcmResponse ?? this.fcmResponse,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
