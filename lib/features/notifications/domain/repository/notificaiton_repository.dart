import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../data/models/params/notifcations_params.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<AppError, List<Notification>>> getNotification();
  Future<Either<AppError, List<Notification>>> syncNotifications();
  Future<Either<AppError, bool>> markAsRead(
      NotificationsParams notificaitonsIds);
  Future<Either<AppError, bool>> deleteNotifications(
      NotificationsParams notificaitonsIds);
  Future<Map<String, int>> getNotificationCounts();
}
