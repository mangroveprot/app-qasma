class NotificationsParams {
  final List<String> notificationIds;

  NotificationsParams({required this.notificationIds});

  Map<String, dynamic> toJson() => {
        'notificationIds': notificationIds,
      };
}
