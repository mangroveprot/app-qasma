import 'package:flutter/material.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../../../theme/theme_extensions.dart';
import '../../data/models/notificaiton_model.dart';
import 'notifcation_card_widget.dart';
import 'notification_empty_content.dart';

class NotificationLoadedContent extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Future<void> Function() onRefresh;
  final Function(List<String>) onMarkAsRead;
  final VoidCallback onMarkAllAsRead;
  final int currentPage;
  final int itemsPerPage;
  final Function(int) onPageChanged;
  final ScrollController scrollController;
  final bool isSelectionMode;
  final Set<String> selectedNotificationIds;
  final Function(String) onNotificationSelect;

  const NotificationLoadedContent({
    Key? key,
    required this.notifications,
    required this.onRefresh,
    required this.onMarkAsRead,
    required this.onMarkAllAsRead,
    required this.currentPage,
    required this.itemsPerPage,
    required this.onPageChanged,
    required this.scrollController,
    required this.isSelectionMode,
    required this.selectedNotificationIds,
    required this.onNotificationSelect,
  }) : super(key: key);

  List<NotificationModel> get sortedNotifications {
    final sorted = List<NotificationModel>.from(notifications);
    sorted.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return sorted;
  }

  List<NotificationModel> get paginatedNotifications {
    final sorted = sortedNotifications;
    final int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    if (end > sorted.length) end = sorted.length;
    return sorted.sublist(start, end);
  }

  int get totalPages =>
      notifications.isEmpty ? 0 : (notifications.length / itemsPerPage).ceil();

  int get unreadCount => notifications.where((n) => n.readAt == null).length;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return NotificationEmptyContent(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        children: [
          if (!isSelectionMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${notifications.length} Notifications',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (unreadCount > 0)
                    TextButton(
                      onPressed: onMarkAllAsRead,
                      style: TextButton.styleFrom(
                        foregroundColor: context.colors.secondary,
                      ),
                      child: Text('Mark all as read ($unreadCount)'),
                    ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ...paginatedNotifications.map(
                  (notification) => NotificationCardWidget(
                    notification: notification,
                    onTap: () => isSelectionMode
                        ? onNotificationSelect(notification.notificationId)
                        : onMarkAsRead([notification.notificationId]),
                    isSelectionMode: isSelectionMode,
                    isSelected: selectedNotificationIds
                        .contains(notification.notificationId),
                  ),
                ),
                if (totalPages > 1)
                  PaginationWidget(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onPageChanged: onPageChanged,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
