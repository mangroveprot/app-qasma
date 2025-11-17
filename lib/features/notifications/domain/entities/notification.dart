import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String notificationId;
  final String userId;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String status;
  final DateTime? sentAt;
  final DateTime? readAt;
  final Map<String, dynamic>? fcmResponse;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Notification({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.status,
    this.sentAt,
    this.readAt,
    this.fcmResponse,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        notificationId,
        userId,
        type,
        title,
        body,
        data,
        status,
        sentAt,
        readAt,
        fcmResponse,
        createdAt,
        updatedAt,
      ];
}
