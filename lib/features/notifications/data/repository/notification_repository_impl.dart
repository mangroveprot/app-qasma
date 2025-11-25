import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../domain/repository/notificaiton_repository.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/entities/notification.dart';
import '../models/params/notifcations_params.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationService _notificationService = sl<NotificationService>();

  @override
  Future<Either<AppError, List<Notification>>> getNotification() async {
    final result = await _notificationService.getNotification();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<AppError, List<Notification>>> syncNotifications() async {
    final result = await _notificationService.syncNotifications();
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<AppError, bool>> markAsRead(
      NotificationsParams notificationParams) async {
    final result = await _notificationService.markAsRead(notificationParams);
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<AppError, bool>> deleteNotifications(
      NotificationsParams notificationParams) async {
    final result =
        await _notificationService.deleteNotifications(notificationParams);
    return result.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }

  @override
  Future<Map<String, int>> getNotificationCounts() {
    return _notificationService.getNotificationCounts();
  }
}
