import 'package:flutter/material.dart';

import 'history_scrollable_content.dart';

class HistoryErrorContent extends StatelessWidget {
  final String error;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final bool isRefreshing;

  const HistoryErrorContent({
    Key? key,
    required this.error,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: HistoryScrollableContent(
        icon: Icons.error_outline,
        title: 'Failed to load appointments',
        subtitle: error,
        action: ElevatedButton(
          onPressed: isRefreshing ? null : onRetry,
          child: isRefreshing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Retry'),
        ),
      ),
    );
  }
}
