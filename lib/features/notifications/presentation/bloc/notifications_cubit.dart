import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../core/_usecase/usecase.dart';
import '../../data/models/notificaiton_model.dart';

part 'notifications_cubit_state.dart';

class NotificationsCubit extends BaseCubit<NotificationCubitState> {
  final Logger _logger = Logger();

  NotificationsCubit() : super(NotificationsInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(NotificationsLoadingState(isRefreshing: isRefreshing));
    }
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(NotificationsInitialState());
    }
  }

  @override
  void emitError({
    String? message,
    List<String>? errorMessages,
    dynamic error,
    StackTrace? stackTrace,
    List<String>? suggestions,
  }) {
    if (isClosed) return;

    final List<String> finalSuggestions =
        error is AppError ? error.suggestions ?? [] : [];

    final List<String> finalErrorMessages = errorMessages ??
        (error is AppError
            ? error.allMessages
            : [message ?? 'Failed to load notifications']);

    emit(
      NotificationsFailureState(
        errorMessages: finalErrorMessages,
        suggestions: finalSuggestions,
      ),
    );
  }

  Future<void> loadNotifications({
    dynamic params,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    if (isClosed) {
      _logger.d('Cubit closed, skipping loadNotifications');
      return;
    }

    emitLoading(isRefreshing: isRefreshing);

    try {
      final Either result = await usecase.call(param: params);

      if (isClosed) {
        _logger.d('Cubit closed after usecase call');
        return;
      }

      result.fold(
        (error) {
          if (isClosed) {
            _logger.d('Cubit closed in fold error callback');
            return;
          }
          _logger.e('Failed to load notifications: $error');
          emitError(
            errorMessages: error.messages ?? ['Failed to load notifications'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          if (isClosed) {
            _logger.d('Cubit closed in fold success callback');
            return;
          }
          final List<NotificationModel> notifications =
              data as List<NotificationModel>;
          _logger
              .i('Successfully loaded ${notifications.length} notifications');
          emit(NotificationsLoadedState(notifications));
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) {
        _logger.d('Cubit closed in catch block');
        return;
      }
      _logger.e('Error loading notifications: $e\n$stackTrace');
      emitError(
        errorMessages: ['Failed to load notifications: ${e.toString()}'],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> loadNotificationsByStatus({
    required String status,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    if (isClosed) return;
    _logger.d('Loading notifications by status: $status');
    await loadNotifications(
      params: {'status': status},
      usecase: usecase,
      isRefreshing: isRefreshing,
    );
  }

  Future<void> loadNotificationsByType({
    required String type,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    if (isClosed) return;
    _logger.d('Loading notifications by type: $type');
    await loadNotifications(
      params: {'type': type},
      usecase: usecase,
      isRefreshing: isRefreshing,
    );
  }

  Future<void> loadUnreadNotifications({
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    if (isClosed) return;
    _logger.d('Loading unread notifications');
    await loadNotifications(
      params: {'status': 'unread'},
      usecase: usecase,
      isRefreshing: isRefreshing,
    );
  }

  Future<void> loadNotificationsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    if (isClosed) return;
    _logger.d('Loading notifications from $startDate to $endDate');
    await loadNotifications(
      params: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
      usecase: usecase,
      isRefreshing: isRefreshing,
    );
  }

  Future<void> refreshNotifications({
    dynamic params,
    required Usecase usecase,
  }) async {
    if (isClosed) return;
    _logger.d('Refreshing notifications');
    await loadNotifications(
      params: params,
      usecase: usecase,
      isRefreshing: true,
    );
  }

  void filterByStatus(String status) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final filteredNotifications = currentState.allNotifications
          .where((notification) =>
              notification.status.toLowerCase() == status.toLowerCase())
          .toList();

      if (isClosed) return;

      _logger.d(
          'Filtered notifications by status: $status (${filteredNotifications.length} results)');
      emit(NotificationsLoadedState(
        filteredNotifications,
        allNotifications: currentState.allNotifications,
      ));
    }
  }

  void filterByType(String type) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final filteredNotifications = currentState.allNotifications
          .where((notification) =>
              notification.type.toLowerCase() == type.toLowerCase())
          .toList();

      if (isClosed) return;

      _logger.d(
          'Filtered notifications by type: $type (${filteredNotifications.length} results)');
      emit(NotificationsLoadedState(
        filteredNotifications,
        allNotifications: currentState.allNotifications,
      ));
    }
  }

  void filterUnread() {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final unreadNotifications = currentState.allNotifications
          .where((notification) => notification.readAt == null)
          .toList();

      if (isClosed) return;

      _logger.d(
          'Filtered unread notifications (${unreadNotifications.length} results)');
      emit(NotificationsLoadedState(
        unreadNotifications,
        allNotifications: currentState.allNotifications,
      ));
    }
  }

  void filterRead() {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final readNotifications = currentState.allNotifications
          .where((notification) => notification.readAt != null)
          .toList();

      if (isClosed) return;

      _logger.d(
          'Filtered read notifications (${readNotifications.length} results)');
      emit(NotificationsLoadedState(
        readNotifications,
        allNotifications: currentState.allNotifications,
      ));
    }
  }

  void clearFilters() {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      if (currentState.allNotifications.isNotEmpty) {
        if (isClosed) return;
        _logger.d(
            'Cleared all filters, showing all ${currentState.allNotifications.length} notifications');
        emit(NotificationsLoadedState(currentState.allNotifications));
      }
    }
  }

  void searchNotifications(String query) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final searchResults = currentState.allNotifications
          .where((notification) =>
              notification.title.toLowerCase().contains(query.toLowerCase()) ||
              notification.body.toLowerCase().contains(query.toLowerCase()) ||
              notification.type.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (isClosed) return;

      _logger.d('Search for "$query" returned ${searchResults.length} results');
      emit(NotificationsLoadedState(
        searchResults,
        allNotifications: currentState.allNotifications,
      ));
    }
  }

  // mark notification as read locally
  void markAsReadLocally(String notificationId) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final updatedNotifications =
          currentState.allNotifications.map((notification) {
        if (notification.notificationId == notificationId) {
          return notification.copyWith(
            readAt: DateTime.now(),
            status: 'read',
          );
        }
        return notification;
      }).toList();

      final updatedFilteredNotifications =
          currentState.notifications.map((notification) {
        if (notification.notificationId == notificationId) {
          return notification.copyWith(
            readAt: DateTime.now(),
            status: 'read',
          );
        }
        return notification;
      }).toList();

      if (isClosed) return;

      _logger.d('Marked notification as read locally: $notificationId');
      emit(NotificationsLoadedState(
        updatedFilteredNotifications,
        allNotifications: updatedNotifications,
      ));
    }
  }

  // revert notif if api fails
  void _revertMarkAsRead(
      String notificationId, NotificationModel originalNotification) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final revertedNotifications =
          currentState.allNotifications.map((notification) {
        if (notification.notificationId == notificationId) {
          return originalNotification;
        }
        return notification;
      }).toList();

      final revertedFilteredNotifications =
          currentState.notifications.map((notification) {
        if (notification.notificationId == notificationId) {
          return originalNotification;
        }
        return notification;
      }).toList();

      if (isClosed) return;

      _logger.w('Reverted mark as read for notification: $notificationId');
      emit(NotificationsLoadedState(
        revertedFilteredNotifications,
        allNotifications: revertedNotifications,
      ));
    }
  }

  void markAllAsReadLocally() {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final now = DateTime.now();
      final updatedNotifications =
          currentState.allNotifications.map((notification) {
        if (notification.readAt == null) {
          return notification.copyWith(
            readAt: now,
            status: 'read',
          );
        }
        return notification;
      }).toList();

      final updatedFilteredNotifications =
          currentState.notifications.map((notification) {
        if (notification.readAt == null) {
          return notification.copyWith(
            readAt: now,
            status: 'read',
          );
        }
        return notification;
      }).toList();

      if (isClosed) return;

      final unreadCount =
          currentState.allNotifications.where((n) => n.readAt == null).length;
      _logger.d('Marked all $unreadCount notifications as read locally');
      emit(NotificationsLoadedState(
        updatedFilteredNotifications,
        allNotifications: updatedNotifications,
      ));
    }
  }

  // API level
  Future<void> markAsRead({
    required String notificationId,
    required Usecase usecase,
  }) async {
    if (isClosed) return;

    _logger.d('Attempting to mark notification as read: $notificationId');

    // Store the original notification before modifying
    NotificationModel? originalNotification;
    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      try {
        originalNotification = currentState.allNotifications.firstWhere(
          (notification) => notification.notificationId == notificationId,
        );
      } catch (e) {
        _logger
            .w('Could not find notification to mark as read: $notificationId');
        return;
      }
    }

    // Optimistically update locally first
    markAsReadLocally(notificationId);

    if (isClosed) return;

    try {
      final Either result = await usecase.call(param: notificationId);

      if (isClosed) return;

      result.fold(
        (error) {
          // API call failed - revert the local change
          _logger.e(
              'Failed to mark notification as read on server: $notificationId - Error: $error');

          if (originalNotification != null) {
            _revertMarkAsRead(notificationId, originalNotification);
          }
        },
        (success) {
          // Successfully synced with server
          _logger.i(
              'Notification marked as read on server successfully: $notificationId');
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) return;

      _logger.e(
          'Exception while marking notification as read: $notificationId - Error: $e\n$stackTrace');

      // Exception occurred - revert the local change
      if (originalNotification != null) {
        _revertMarkAsRead(notificationId, originalNotification);
      }
    }
  }

  Future<void> markAllAsRead({
    required Usecase usecase,
  }) async {
    if (isClosed) return;

    _logger.d('Attempting to mark all notifications as read');

    // Store original state
    final originalState = state is NotificationsLoadedState
        ? (state as NotificationsLoadedState)
        : null;

    if (originalState != null) {
      final unreadCount =
          originalState.allNotifications.where((n) => n.readAt == null).length;
      _logger.d('Found $unreadCount unread notifications to mark as read');
    }

    // Optimistically update locally
    markAllAsReadLocally();

    if (isClosed) return;

    try {
      final Either result = await usecase.call(param: null);

      if (isClosed) return;

      result.fold(
        (error) {
          // API call failed - revert to original state
          _logger.e(
              'Failed to mark all notifications as read on server - Error: $error');

          if (originalState != null) {
            if (isClosed) return;
            emit(originalState);
          }
        },
        (success) {
          _logger.i('All notifications marked as read on server successfully');
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) return;

      _logger.e(
          'Exception while marking all notifications as read - Error: $e\n$stackTrace');

      // Exception occurred - revert to original state
      if (originalState != null) {
        if (isClosed) return;
        emit(originalState);
      }
    }
  }

  @override
  Future<void> close() {
    _logger.d('Closing NotificationsCubit');
    return super.close();
  }
}
