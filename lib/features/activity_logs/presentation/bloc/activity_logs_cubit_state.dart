part of 'activity_logs_cubit.dart';

abstract class ActivityLogsCubitState extends BaseState {}

class ActivityLogsInitialState extends ActivityLogsCubitState {}

class ActivityLogsLoadingState extends ActivityLogsCubitState {
  final bool isRefreshing;

  ActivityLogsLoadingState({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class ActivityLogsLoadedState extends ActivityLogsCubitState {
  final List<ActivityLogModel> activityLogs;

  ActivityLogsLoadedState(this.activityLogs);

  @override
  List<Object?> get props => [activityLogs];

  bool get isEmpty => activityLogs.isEmpty;
  bool get isNotEmpty => activityLogs.isNotEmpty;
  int get count => activityLogs.length;

  List<ActivityLogModel> getByCategory(ActivityCategory category) {
    return activityLogs.where((log) => log.category == category).toList();
  }

  List<ActivityLogModel> getByAction(String action) {
    return activityLogs
        .where((log) => log.action.toLowerCase().contains(action.toLowerCase()))
        .toList();
  }

  List<ActivityLogModel> get recentLogs {
    final yesterday = DateTime.now().subtract(const Duration(hours: 24));
    return activityLogs
        .where((log) => log.createdAt.isAfter(yesterday))
        .toList();
  }

  List<ActivityLogModel> get todayLogs {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return activityLogs
        .where((log) => log.createdAt.isAfter(startOfDay))
        .toList();
  }

  Map<ActivityCategory, List<ActivityLogModel>> get groupedByCategory {
    final Map<ActivityCategory, List<ActivityLogModel>> grouped = {};
    for (var log in activityLogs) {
      if (!grouped.containsKey(log.category)) {
        grouped[log.category] = [];
      }
      grouped[log.category]!.add(log);
    }
    return grouped;
  }

  Map<String, List<ActivityLogModel>> get groupedByDate {
    final Map<String, List<ActivityLogModel>> grouped = {};
    for (var log in activityLogs) {
      final dateKey = _formatDateKey(log.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(log);
    }
    return grouped;
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class ActivityLogsFailureState extends ActivityLogsCubitState {
  final List<String> errorMessages;
  final List<String> suggestions;

  ActivityLogsFailureState({
    this.suggestions = const [],
    required this.errorMessages,
  });

  @override
  List<Object?> get props => [suggestions, errorMessages];

  String get primaryError =>
      errorMessages.isNotEmpty ? errorMessages.first : 'Unknown error occurred';

  bool get hasMultipleErrors => errorMessages.length > 1;

  String get formattedMessage {
    if (errorMessages.length <= 1) {
      return primaryError;
    }
    return '${errorMessages.first}\n• ${errorMessages.skip(1).join('\n• ')}';
  }

  String get combinedMessage => errorMessages.join(', ');
}
