import 'package:flutter/material.dart';

import 'history_scrollable_content.dart';

class HistoryEmptyContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const HistoryEmptyContent({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const HistoryScrollableContent(
        icon: Icons.calendar_today_outlined,
        title: 'No history of appointments',
        subtitle: '',
      ),
    );
  }
}
