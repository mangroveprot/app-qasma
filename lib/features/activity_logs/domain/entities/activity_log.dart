import 'package:equatable/equatable.dart';

enum ActivityCategory {
  account,
  appointment,
  security,
  system,
}

class ActivityLog extends Equatable {
  final String activityId;
  final String? userId;
  final ActivityCategory category;
  final String action;
  final String? relatedId;
  final Map<String, dynamic> details;
  final String? ipAddress;
  final String? device;
  final String? userAgent;
  final String? platform;
  final String? appVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? deletedAt;
  final String? deletedBy;

  const ActivityLog({
    required this.activityId,
    this.userId,
    required this.category,
    required this.action,
    this.relatedId,
    required this.details,
    this.ipAddress,
    this.device,
    this.userAgent,
    this.platform,
    this.appVersion,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  @override
  List<Object?> get props => [
        activityId,
        userId,
        category,
        action,
        relatedId,
        details,
        ipAddress,
        device,
        userAgent,
        platform,
        appVersion,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
        deletedAt,
        deletedBy,
      ];
}
