import 'package:equatable/equatable.dart';

import 'activity_log_model.dart';

class ActivityLogsPageResult extends Equatable {
  final List<ActivityLogModel> logs;
  final int page;
  final int limit;
  final int total;
  final bool hasMore;
  final String? searchTerm;

  const ActivityLogsPageResult({
    required this.logs,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasMore,
    this.searchTerm,
  });

  @override
  List<Object?> get props => [logs, page, limit, total, hasMore, searchTerm];
}

