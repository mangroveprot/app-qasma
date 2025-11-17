import 'package:flutter/material.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../data/models/notificaiton_model.dart';
import 'notifcation_card_widget.dart';
import 'notification_empty_content.dart';

class NotificationLoadedContent extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Future<void> Function() onRefresh;
  final Function(String) onMarkAsRead;
  final int currentPage;
  final int itemsPerPage;
  final Function(int) onPageChanged;
  final ScrollController scrollController;

  const NotificationLoadedContent({
    Key? key,
    required this.notifications,
    required this.onRefresh,
    required this.onMarkAsRead,
    required this.currentPage,
    required this.itemsPerPage,
    required this.onPageChanged,
    required this.scrollController,
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

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return NotificationEmptyContent(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ...paginatedNotifications.map(
            (notification) => NotificationCardWidget(
              notification: notification,
              onTap: () => onMarkAsRead(notification.notificationId),
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
    );
  }
}
