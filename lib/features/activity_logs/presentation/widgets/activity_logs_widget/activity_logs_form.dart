import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/custom_filter_bar.dart';
import '../../../data/models/activity_log_model.dart';
import '../../../domain/entities/activity_log.dart';
import '../../bloc/activity_logs_cubit.dart';
import '../../config/activity_logs_config.dart';
import '../../pages/activity_logs_page.dart';
import 'activity_logs_error_content.dart';
import 'activity_logs_loaded_content.dart';
import 'activtiy_logs_empty_content.dart';

class ActivityLogsForm extends StatefulWidget {
  final ActivityLogsPageState state;
  const ActivityLogsForm({super.key, required this.state});

  @override
  State<ActivityLogsForm> createState() => _ActivityLogsFormState();
}

class _ActivityLogsFormState extends State<ActivityLogsForm> {
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  static const Duration _refreshCooldown = Duration(seconds: 30);

  List<ActivityLogModel>? _cachedFilteredLogs;
  ActivityLogsLoadedState? _lastProcessedState;
  ActivityLogFilterStatus _selectedFilter = ActivityLogFilterStatus.all;

  String? _expandedId;

  List<ActivityLogModel> getFilteredLogs(ActivityLogsLoadedState state) {
    if (_cachedFilteredLogs == null || _lastProcessedState != state) {
      _cachedFilteredLogs = _filterByStatus(state.activityLogs);
      _lastProcessedState = state;
    }
    return _cachedFilteredLogs!;
  }

  List<ActivityLogModel> _filterByStatus(List<ActivityLogModel> logs) {
    List<ActivityLogModel> filtered;

    switch (_selectedFilter) {
      case ActivityLogFilterStatus.all:
        filtered = [...logs];
        break;
      case ActivityLogFilterStatus.account:
        filtered =
            logs.where((l) => l.category == ActivityCategory.account).toList();
        break;
      case ActivityLogFilterStatus.appointment:
        filtered = logs
            .where((l) => l.category == ActivityCategory.appointment)
            .toList();
        break;
      case ActivityLogFilterStatus.security:
        filtered =
            logs.where((l) => l.category == ActivityCategory.security).toList();
        break;
      case ActivityLogFilterStatus.system:
        filtered =
            logs.where((l) => l.category == ActivityCategory.system).toList();
        break;
    }

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  void _onFilterChanged(ActivityLogFilterStatus status) {
    setState(() {
      _selectedFilter = status;
      _cachedFilteredLogs = null;
      _lastProcessedState = null;
      _expandedId = null;
    });
  }

  void _onCardExpanded(String? id) {
    setState(() => _expandedId = id);
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await widget.state.controller.refreshActivityLogs();
      _lastRefreshTime = DateTime.now();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  bool get _shouldThrottle {
    return _lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) < _refreshCooldown;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdownFilter<ActivityLogFilterStatus>(
          options: const [
            FilterOption(label: 'All', value: ActivityLogFilterStatus.all),
            FilterOption(
                label: 'Account', value: ActivityLogFilterStatus.account),
            FilterOption(
                label: 'Appointment',
                value: ActivityLogFilterStatus.appointment),
            FilterOption(
                label: 'Security', value: ActivityLogFilterStatus.security),
            FilterOption(
                label: 'System', value: ActivityLogFilterStatus.system),
          ],
          onFilterChanged: _onFilterChanged,
          initialSelection: _selectedFilter,
        ),
        Expanded(
          child: BlocBuilder<ActivityLogsCubit, ActivityLogsCubitState>(
            buildWhen: (previous, current) {
              if (previous.runtimeType != current.runtimeType) return true;
              if (current is ActivityLogsLoadedState &&
                  previous is ActivityLogsLoadedState) {
                return previous.activityLogs != current.activityLogs;
              }
              return false;
            },
            builder: (context, state) {
              if (state is ActivityLogsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ActivityLogsLoadedState) {
                return ActivityLogsLoadedContent(
                  logs: getFilteredLogs(state),
                  users: widget.state.controller.getUsers(),
                  onRefresh: _onRefresh,
                  expandedId: _expandedId,
                  onCardExpanded: _onCardExpanded,
                );
              }

              if (state is ActivityLogsFailureState) {
                return ActivityLogsErrorContent(
                  error: state.primaryError,
                  onRefresh: _onRefresh,
                  onRetry: widget.state.controller.refreshActivityLogs,
                  isRefreshing: _isRefreshing,
                );
              }

              return ActivityLogsEmptyContent(onRefresh: _onRefresh);
            },
          ),
        ),
      ],
    );
  }
}
