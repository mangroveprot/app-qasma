import 'package:flutter/material.dart';

import '../../../../appointment/presentation/widgets/history_widget/history_scrollable_content.dart';

class ActivityLogsEmptyContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const ActivityLogsEmptyContent({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: const HistoryScrollableContent(
        icon: Icons.receipt_long_outlined,
        title: 'No activity logs found',
        subtitle: '',
      ),
    );
  }
}
