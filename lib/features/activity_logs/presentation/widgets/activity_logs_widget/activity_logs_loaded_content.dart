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
  final String? expandedId;
  final void Function(String? id) onCardExpanded;

  const ActivityLogsLoadedContent({
    super.key,
    required this.logs,
    this.users,
    required this.onRefresh,
    required this.expandedId,
    required this.onCardExpanded,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return ActivityLogsEmptyContent(onRefresh: onRefresh);
    }

    final grouped = groupLogsByDate(logs);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        physics: const BouncingScrollPhysics(),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final dateLabel = grouped.keys.elementAt(index);
          final dateLogs = grouped[dateLabel]!;

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
