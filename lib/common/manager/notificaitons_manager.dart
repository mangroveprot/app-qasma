import '../../features/notifications/domain/usecases/get_notification_counts_usecase.dart';
import '../../features/notifications/domain/usecases/sync_notification_usecase.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../infrastructure/injection/service_locator.dart';

class NotificationsManager {
  late final SyncNotificationsUsecase _syncNotificationsUsecase;
  late final GetNotificationCountsUsecase _getNotificationCountsUsecase;

  NotificationsManager() {
    _syncNotificationsUsecase = sl<SyncNotificationsUsecase>();
    _getNotificationCountsUsecase = sl<GetNotificationCountsUsecase>();
  }

  Future<void> refreshNotifications(NotificationsCubit cubit) async {
    await cubit.refreshNotifications(usecase: _syncNotificationsUsecase);
  }

  Future<int> getUnreadCounts() async {
    final counts = await _getNotificationCountsUsecase();
    final unreadCount = counts['unread'] ?? 0;
    return unreadCount;
  }
}
