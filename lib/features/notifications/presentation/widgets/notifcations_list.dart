import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/notificaiton_model.dart';
import '../../presentation/bloc/notifications_cubit.dart';
import '../../presentation/pages/notifications_page.dart';
import 'loaded_content.dart';
import 'notificaiton_error_content.dart';
import 'notification_empty_content.dart';

class NotificationsListWidget extends StatefulWidget {
  final NotificationsPageState state;

  const NotificationsListWidget({
    super.key,
    required this.state,
  });

  @override
  State<NotificationsListWidget> createState() =>
      _NotificationsListWidgetState();
}

class _NotificationsListWidgetState extends State<NotificationsListWidget> {
  int currentPage = 0;
  final int itemsPerPage = 10;
  DateTime? _lastRefreshTime;
  bool _isRefreshing = false;
  static const Duration _refreshCooldown = Duration(seconds: 30);

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<NotificationModel> getPaginatedNotifications(
      List<NotificationModel> notifications) {
    final int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    if (end > notifications.length) end = notifications.length;
    return notifications.sublist(start, end);
  }

  int getTotalPages(int totalCount) =>
      totalCount == 0 ? 0 : (totalCount / itemsPerPage).ceil();

  void markAsRead(String id) {
    final cubit = context.read<NotificationsCubit>();
    cubit.markAsRead(
      notificationId: id,
      usecase: widget.state.controller.markAsReadUsecase,
    );
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing || _shouldThrottle) return;

    setState(() => _isRefreshing = true);

    try {
      await widget.state.controller.loadNotificationsData(
        context.read<NotificationsCubit>(),
      );
      _lastRefreshTime = DateTime.now();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  bool get _shouldThrottle {
    return _lastRefreshTime != null &&
        DateTime.now().difference(_lastRefreshTime!) < _refreshCooldown;
  }

  void _handlePageChange(int newPage) {
    setState(() => currentPage = newPage);

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationCubitState>(
      buildWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) return true;

        if (previous is NotificationsLoadingState ||
            current is NotificationsLoadingState) return true;

        if (previous is NotificationsLoadedState &&
            current is NotificationsLoadedState) {
          return previous.notifications != current.notifications ||
              previous.allNotifications != current.allNotifications;
        }

        return false;
      },
      builder: (context, state) {
        if (state is NotificationsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationsLoadedState) {
          return NotificationLoadedContent(
            notifications: state.notifications,
            onRefresh: _onRefresh,
            onMarkAsRead: markAsRead,
            currentPage: currentPage,
            itemsPerPage: itemsPerPage,
            onPageChanged: _handlePageChange,
            scrollController: _scrollController,
          );
        }

        if (state is NotificationsFailureState) {
          return NotificationErrorContent(
            error: state.primaryError,
            onRefresh: _onRefresh,
            onRetry: () => widget.state.controller.loadNotificationsData(
              context.read<NotificationsCubit>(),
            ),
            isRefreshing: _isRefreshing,
          );
        }

        return NotificationEmptyContent(onRefresh: _onRefresh);
      },
    );
  }
}
