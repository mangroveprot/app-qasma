import 'package:flutter/material.dart';

import '../../../data/models/activity_log_model.dart';
import '../../../../users/data/models/user_model.dart';
import '../../utils/activity_logs_util.dart';
import 'activity_logs_card.dart';
import 'activtiy_logs_empty_content.dart';

class ActivityLogsLoadedContent extends StatelessWidget {
  final List<ActivityLogModel> logs;
  final List<UserModel>? users;
  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;
  final int total;
  final String? expandedId;
  final void Function(String? id) onCardExpanded;

  const ActivityLogsLoadedContent({
    super.key,
    required this.logs,
    this.users,
    required this.onRefresh,
    this.onLoadMore,
    required this.hasMore,
    required this.isLoadingMore,
    required this.total,
    required this.expandedId,
    required this.onCardExpanded,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return ActivityLogsEmptyContent(onRefresh: onRefresh);
    }

    final grouped = groupLogsByDate(logs);

    final allSections = grouped.entries.toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        physics: const BouncingScrollPhysics(),
        itemCount: allSections.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                left: 4,
                right: 4,
              ),
              child: Text(
                'Total logs: $total',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF777777),
                ),
              ),
            );
          }

          if (index == allSections.length + 1) {
            if (!hasMore || onLoadMore == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: isLoadingMore ? null : () => onLoadMore!(),
                  child: isLoadingMore
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Load more'),
                ),
              ),
            );
          }

          final section = allSections[index - 1];
          final dateLabel = section.key;
          final dateLogs = section.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateSeparator(label: dateLabel),
              ...dateLogs.map(
                (log) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RepaintBoundary(
                    child: ActivityLogsCard(
                      log: log,
                      users: users,
                      isExpanded: expandedId == log.activityId,
                      onTap: () => onCardExpanded(
                        expandedId == log.activityId ? null : log.activityId,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final String label;
  const _DateSeparator({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(height: 1, color: const Color(0xFFEEEEEE)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFFAAAAAA),
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Container(height: 1, color: const Color(0xFFEEEEEE)),
          ),
        ],
      ),
    );
  }
}
