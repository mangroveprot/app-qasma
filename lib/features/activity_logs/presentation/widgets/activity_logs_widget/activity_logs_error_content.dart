import 'package:flutter/material.dart';

import '../../../../appointment/presentation/widgets/history_widget/history_scrollable_content.dart';

class ActivityLogsErrorContent extends StatelessWidget {
  final String error;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onRetry;
  final bool isRefreshing;

  const ActivityLogsErrorContent({
    super.key,
    required this.error,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: HistoryScrollableContent(
        icon: Icons.error_outline_rounded,
        title: 'Something went wrong',
        subtitle: error,
        action: ElevatedButton.icon(
          onPressed: isRefreshing ? null : onRetry,
          icon: isRefreshing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Retry'),
        ),
      ),
    );
  }
}
