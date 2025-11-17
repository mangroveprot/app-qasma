import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<AppError, List<Notification>>> getNotification();
  Future<Either<AppError, List<Notification>>> syncNotifications();
  Future<Either<AppError, bool>> markAsRead(String notificationId);
  Future<Map<String, int>> getNotificationCounts();
}
