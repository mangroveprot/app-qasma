part of 'notifications_cubit.dart';

abstract class NotificationCubitState extends BaseState {}

class NotificationsInitialState extends NotificationCubitState {}

class NotificationsLoadingState extends NotificationCubitState {
  final bool isRefreshing;

  NotificationsLoadingState({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class NotificationsLoadedState extends NotificationCubitState {
  final List<NotificationModel> notifications;
  final List<NotificationModel> allNotifications;

  NotificationsLoadedState(
    this.notifications, {
    List<NotificationModel>? allNotifications,
  }) : allNotifications = allNotifications ?? notifications;

  @override
  List<Object?> get props => [notifications, allNotifications];

  // Helper getters
  bool get isEmpty => notifications.isEmpty;
  bool get isNotEmpty => notifications.isNotEmpty;
  int get count => notifications.length;

  // Get notifications by status
  List<NotificationModel> getByStatus(String status) {
    return notifications
        .where((notification) =>
            notification.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get notifications by type
  List<NotificationModel> getByType(String type) {
    return notifications
        .where((notification) =>
            notification.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  // Get unread notifications
  List<NotificationModel> get unreadNotifications {
    return allNotifications
        .where((notification) => notification.readAt == null)
        .toList();
  }

  // Get read notifications
  List<NotificationModel> get readNotifications {
    return allNotifications
        .where((notification) => notification.readAt != null)
        .toList();
  }

  // Get unread count
  int get unreadCount => unreadNotifications.length;

  // Get read count
  int get readCount => readNotifications.length;

  // Check if has unread
  bool get hasUnread => unreadCount > 0;

  // Get recent notifications (last 24 hours)
  List<NotificationModel> get recentNotifications {
    final yesterday = DateTime.now().subtract(const Duration(hours: 24));
    return notifications
        .where((notification) => notification.createdAt.isAfter(yesterday))
        .toList();
  }

  // Get today's notifications
  List<NotificationModel> get todayNotifications {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return notifications
        .where((notification) => notification.createdAt.isAfter(startOfDay))
        .toList();
  }

  // Get notifications sent in a specific date range
  List<NotificationModel> getByDateRange(DateTime start, DateTime end) {
    return notifications
        .where((notification) =>
            notification.createdAt.isAfter(start) &&
            notification.createdAt.isBefore(end))
        .toList();
  }

  // Group notifications by type
  Map<String, List<NotificationModel>> get groupedByType {
    final Map<String, List<NotificationModel>> grouped = {};
    for (var notification in notifications) {
      if (!grouped.containsKey(notification.type)) {
        grouped[notification.type] = [];
      }
      grouped[notification.type]!.add(notification);
    }
    return grouped;
  }

  // Group notifications by status
  Map<String, List<NotificationModel>> get groupedByStatus {
    final Map<String, List<NotificationModel>> grouped = {};
    for (var notification in notifications) {
      if (!grouped.containsKey(notification.status)) {
        grouped[notification.status] = [];
      }
      grouped[notification.status]!.add(notification);
    }
    return grouped;
  }
}

class NotificationsFailureState extends NotificationCubitState {
  final List<String> errorMessages;
  final List<String> suggestions;

  NotificationsFailureState({
    this.suggestions = const [],
    required this.errorMessages,
  });

  @override
  List<Object?> get props => [suggestions, errorMessages];

  String get primaryError =>
      errorMessages.isNotEmpty ? errorMessages.first : 'Unknown error occurred';

  bool get hasMultipleErrors => errorMessages.length > 1;

  String get formattedMessage {
    if (errorMessages.length <= 1) {
      return primaryError;
    }
    return '${errorMessages.first}\n• ${errorMessages.skip(1).join('\n• ')}';
  }

  String get combinedMessage => errorMessages.join(', ');
}
