import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/custom_search_bar.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../data/models/activity_log_model.dart';
import '../../../domain/entities/activity_log.dart';
import '../../bloc/activity_logs_cubit.dart';
import '../../config/activity_logs_config.dart';
import '../../models/activity_logs_filter_model.dart';
import '../../pages/activity_logs_page.dart';
import 'activity_logs_error_content.dart';
import 'activity_logs_filter_bottom_sheet.dart';
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
  static const int _pageLimit = 20;

  ActivityLogsFilterModel _advancedFilter = const ActivityLogsFilterModel();

  String? _expandedId;
  Timer? _searchDebounce;
  String _searchTerm = '';

  List<ActivityLogModel> _applyFilters(
    List<ActivityLogModel> logs,
    List<UserModel>? users,
  ) {
    List<ActivityLogModel> filtered;

    switch (_advancedFilter.status) {
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

    // Date range (inclusive)
    if (_advancedFilter.dateFrom != null) {
      final from = DateTime(
        _advancedFilter.dateFrom!.year,
        _advancedFilter.dateFrom!.month,
        _advancedFilter.dateFrom!.day,
      );
      filtered =
          filtered.where((log) => !log.createdAt.isBefore(from)).toList();
    }

    if (_advancedFilter.dateTo != null) {
      final to = DateTime(
        _advancedFilter.dateTo!.year,
        _advancedFilter.dateTo!.month,
        _advancedFilter.dateTo!.day,
        23,
        59,
        59,
        999,
      );
      filtered = filtered.where((log) => !log.createdAt.isAfter(to)).toList();
    }

    // Exclude roles (global), then apply role filter when not 'all'.
    if (users != null &&
        users.isNotEmpty &&
        excludedActivityLogRoles.isNotEmpty) {
      final excluded =
          excludedActivityLogRoles.map((r) => r.toLowerCase().trim()).toSet();

      filtered = filtered.where((log) {
        final user = _findUserById(users, log.userId);
        if (user == null) return true;
        final role = user.role.toLowerCase().trim();
        return !excluded.contains(role);
      }).toList();
    }

    // Role filter based on linked user role
    final roleFilter = _advancedFilter.role.toLowerCase();
    if (roleFilter != 'all') {
      filtered = filtered.where((log) {
        final user = _findUserById(users, log.userId);
        if (user == null) return false;
        final userRole = (user.role).toLowerCase();
        return userRole == roleFilter;
      }).toList();
    }

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  void _onAdvancedFilterChanged(ActivityLogsFilterModel filter) {
    setState(() {
      _advancedFilter = filter;
      _expandedId = null;
    });
  }

  void _openAdvancedFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ActivityLogsFilterBottomSheet(
          initialFilter: _advancedFilter,
          onApply: _onAdvancedFilterChanged,
        );
      },
    );
  }

  UserModel? _findUserById(List<UserModel>? users, String? userId) {
    if (userId == null || userId.isEmpty) return null;
    if (users == null || users.isEmpty) return null;
    try {
      return users.firstWhere((u) => u.idNumber == userId);
    } catch (_) {
      return null;
    }
  }

  void _onCardExpanded(String? id) {
    setState(() => _expandedId = id);
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await widget.state.controller.refreshActivityLogs(forceRefresh: true);
      _lastRefreshTime = DateTime.now();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  bool get _shouldThrottle {
    return _lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) < _refreshCooldown;
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      _searchTerm = value.trim();
      await widget.state.controller.refreshActivityLogs(
        forceRefresh: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActivityLogsSearchBar(
          onSearchChanged: _onSearchChanged,
          onFilterPressed: _openAdvancedFilterSheet,
          hasActiveFilter: _advancedFilter.hasActiveFilters,
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
                final users = widget.state.controller.getUsers();
                final logs = _applyFilters(state.activityLogs, users);
                return ActivityLogsLoadedContent(
                  logs: logs,
                  users: users,
                  onRefresh: _onRefresh,
                  onLoadMore:
                      state.hasMore ? widget.state.controller.loadMore : null,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  total: state.total,
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

class _ActivityLogsSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;
  final bool hasActiveFilter;

  const _ActivityLogsSearchBar({
    required this.onSearchChanged,
    required this.onFilterPressed,
    required this.hasActiveFilter,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final shadows = context.shadows;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              onSearchChanged: onSearchChanged,
              hintText: 'Search logs...',
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                onTap: onFilterPressed,
                borderRadius: radius.medium,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: colors.white.withOpacity(0.8),
                    borderRadius: radius.medium,
                    border:
                        Border.all(color: colors.textPrimary.withOpacity(0.1)),
                    boxShadow: [shadows.light],
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    size: 22,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (hasActiveFilter)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
