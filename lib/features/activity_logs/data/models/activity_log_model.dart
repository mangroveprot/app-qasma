import 'dart:convert';
import '../../../../common/utils/model_utils.dart';
import '../../domain/entities/activity_log.dart';

class ActivityLogModel extends ActivityLog {
  const ActivityLogModel({
    required super.activityId,
    super.userId,
    required super.category,
    required super.action,
    super.relatedId,
    required super.details,
    super.ipAddress,
    super.device,
    super.userAgent,
    super.platform,
    super.appVersion,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    super.deletedAt,
    super.deletedBy,
  });

  // To SQLite database
  Map<String, dynamic> toDb() {
    return {
      'activityId': activityId,
      'userId': userId,
      'category': category.name,
      'action': action,
      'relatedId': relatedId,
      'details': jsonEncode(details),
      'ipAddress': ipAddress,
      'device': device,
      'userAgent': userAgent,
      'platform': platform,
      'appVersion': appVersion,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  // From SQLite database
  factory ActivityLogModel.fromDb(Map<String, dynamic> map) {
    return ActivityLogModel(
      activityId: ModelUtils.getString(map, 'activityId'),
      userId: ModelUtils.getNullableString(map, 'userId'),
      category: _parseCategory(ModelUtils.getString(map, 'category')),
      action: ModelUtils.getString(map, 'action'),
      relatedId: ModelUtils.getNullableString(map, 'relatedId'),
      details: map['details'] != null
          ? jsonDecode(map['details']) as Map<String, dynamic>
          : {},
      ipAddress: ModelUtils.getNullableString(map, 'ipAddress'),
      device: ModelUtils.getNullableString(map, 'device'),
      userAgent: ModelUtils.getNullableString(map, 'userAgent'),
      platform: ModelUtils.getNullableString(map, 'platform'),
      appVersion: ModelUtils.getNullableString(map, 'appVersion'),
      createdAt: ModelUtils.getDateTime(map, 'createdAt'),
      updatedAt: ModelUtils.getDateTime(map, 'updatedAt'),
      createdBy: ModelUtils.getNullableString(map, 'createdBy'),
      updatedBy: ModelUtils.getNullableString(map, 'updatedBy'),
      deletedAt: ModelUtils.getNullableDateTime(map, 'deletedAt'),
      deletedBy: ModelUtils.getNullableString(map, 'deletedBy'),
    );
  }

  // To JSON (for API)
  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'userId': userId,
      'category': category.name,
      'action': action,
      'relatedId': relatedId,
      'details': details,
      'ipAddress': ipAddress,
      'device': device,
      'userAgent': userAgent,
      'platform': platform,
      'appVersion': appVersion,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'deletedBy': deletedBy,
    };
  }

  // From JSON (from API)
  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      activityId: ModelUtils.getString(json, 'activityId'),
      userId: ModelUtils.getNullableString(json, 'userId'),
      category: _parseCategory(ModelUtils.getString(json, 'category')),
      action: ModelUtils.getString(json, 'action'),
      relatedId: ModelUtils.getNullableString(json, 'relatedId'),
      details: json['details'] as Map<String, dynamic>? ?? {},
      ipAddress: ModelUtils.getNullableString(json, 'ipAddress'),
      device: ModelUtils.getNullableString(json, 'device'),
      userAgent: ModelUtils.getNullableString(json, 'userAgent'),
      platform: ModelUtils.getNullableString(json, 'platform'),
      appVersion: ModelUtils.getNullableString(json, 'appVersion'),
      createdAt: ModelUtils.getDateTime(json, 'createdAt'),
      updatedAt: ModelUtils.getDateTime(json, 'updatedAt'),
      createdBy: ModelUtils.getNullableString(json, 'createdBy'),
      updatedBy: ModelUtils.getNullableString(json, 'updatedBy'),
      deletedAt: ModelUtils.getNullableDateTime(json, 'deletedAt'),
      deletedBy: ModelUtils.getNullableString(json, 'deletedBy'),
    );
  }

  // Convert to entity
  ActivityLog toEntity() {
    return ActivityLog(
      activityId: activityId,
      userId: userId,
      category: category,
      action: action,
      relatedId: relatedId,
      details: details,
      ipAddress: ipAddress,
      device: device,
      userAgent: userAgent,
      platform: platform,
      appVersion: appVersion,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
      deletedAt: deletedAt,
      deletedBy: deletedBy,
    );
  }

  // Create from entity
  factory ActivityLogModel.fromEntity(ActivityLog entity) {
    return ActivityLogModel(
      activityId: entity.activityId,
      userId: entity.userId,
      category: entity.category,
      action: entity.action,
      relatedId: entity.relatedId,
      details: entity.details,
      ipAddress: entity.ipAddress,
      device: entity.device,
      userAgent: entity.userAgent,
      platform: entity.platform,
      appVersion: entity.appVersion,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      deletedAt: entity.deletedAt,
      deletedBy: entity.deletedBy,
    );
  }

  // Copy with
  ActivityLogModel copyWith({
    String? activityId,
    String? userId,
    ActivityCategory? category,
    String? action,
    String? relatedId,
    Map<String, dynamic>? details,
    String? ipAddress,
    String? device,
    String? userAgent,
    String? platform,
    String? appVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    DateTime? deletedAt,
    String? deletedBy,
  }) {
    return ActivityLogModel(
      activityId: activityId ?? this.activityId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      action: action ?? this.action,
      relatedId: relatedId ?? this.relatedId,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      device: device ?? this.device,
      userAgent: userAgent ?? this.userAgent,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
    );
  }

  // Helper to parse category from string
  static ActivityCategory _parseCategory(String categoryStr) {
    switch (categoryStr.toLowerCase()) {
      case 'account':
        return ActivityCategory.account;
      case 'appointment':
        return ActivityCategory.appointment;
      case 'security':
        return ActivityCategory.security;
      case 'system':
        return ActivityCategory.system;
      default:
        return ActivityCategory.system;
    }
  }
}
