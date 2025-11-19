import 'package:flutter/material.dart';

import 'notification_scrollable_content.dart';

class NotificationEmptyContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const NotificationEmptyContent({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const NotificationScrollableContent(
        icon: Icons.notifications_none,
        title: 'No notifications yet',
        subtitle: 'You will see your notifications here',
      ),
    );
  }
}
