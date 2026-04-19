import 'package:flutter/material.dart';

import '../home_content.dart';

class ErrorContent extends StatelessWidget {
  final String error;
  final String userName;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final bool isRefreshing;

  const ErrorContent({
    Key? key,
    required this.error,
    required this.onRefresh,
    required this.onRetry,
    required this.isRefreshing,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ScrollableContent(
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
          ),
        ),
      ],
    );
  }
}
