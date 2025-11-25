import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../core/_usecase/usecase.dart';
import '../../data/models/notificaiton_model.dart';
import '../../data/models/params/notifcations_params.dart';

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

  void markManyAsReadLocally(List<String> notificationIds) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final now = DateTime.now();
      final idSet = notificationIds.toSet();

      final updatedNotifications =
          currentState.allNotifications.map((notification) {
        if (idSet.contains(notification.notificationId)) {
          return notification.copyWith(readAt: now, status: 'read');
        }
        return notification;
      }).toList();

      final updatedFilteredNotifications =
          currentState.notifications.map((notification) {
        if (idSet.contains(notification.notificationId)) {
          return notification.copyWith(readAt: now, status: 'read');
        }
        return notification;
      }).toList();

      if (isClosed) return;

      _logger
          .d('Marked ${notificationIds.length} notifications as read locally');
      emit(NotificationsLoadedState(
        updatedFilteredNotifications,
        allNotifications: updatedNotifications,
      ));
    }
  }

  void deleteManyLocally(List<String> notificationIds) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final idSet = notificationIds.toSet();

      final updatedNotifications = currentState.allNotifications
          .where((notification) => !idSet.contains(notification.notificationId))
          .toList();

      final updatedFilteredNotifications = currentState.notifications
          .where((notification) => !idSet.contains(notification.notificationId))
          .toList();

      if (isClosed) return;

      _logger.d('Deleted ${notificationIds.length} notifications locally');
      emit(NotificationsLoadedState(
        updatedFilteredNotifications,
        allNotifications: updatedNotifications,
      ));
    }
  }

  void _revertDeleteMany(List<NotificationModel> deletedNotifications) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;

      final restoredNotifications = [
        ...currentState.allNotifications,
        ...deletedNotifications,
      ];

      final restoredFilteredNotifications = [
        ...currentState.notifications,
        ...deletedNotifications,
      ];

      if (isClosed) return;

      _logger.w(
          'Reverted deletion of ${deletedNotifications.length} notifications');
      emit(NotificationsLoadedState(
        restoredFilteredNotifications,
        allNotifications: restoredNotifications,
      ));
    }
  }

  void _revertMarkManyAsRead(List<NotificationModel> originalNotifications) {
    if (isClosed) return;

    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final originalMap = {
        for (var n in originalNotifications) n.notificationId: n
      };

      final revertedNotifications =
          currentState.allNotifications.map((notification) {
        return originalMap[notification.notificationId] ?? notification;
      }).toList();

      final revertedFilteredNotifications =
          currentState.notifications.map((notification) {
        return originalMap[notification.notificationId] ?? notification;
      }).toList();

      if (isClosed) return;

      _logger.w('Reverted ${originalNotifications.length} notifications');
      emit(NotificationsLoadedState(
        revertedFilteredNotifications,
        allNotifications: revertedNotifications,
      ));
    }
  }

  Future<void> markAsRead({
    required List<String> notificationIds,
    required Usecase usecase,
  }) async {
    if (isClosed) return;

    _logger.d(
        'Attempting to mark ${notificationIds.length} notifications as read');

    List<NotificationModel> originalNotifications = [];
    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final idSet = notificationIds.toSet();
      originalNotifications = currentState.allNotifications
          .where((n) => idSet.contains(n.notificationId))
          .toList();
    }

    markManyAsReadLocally(notificationIds);

    if (isClosed) return;

    try {
      final Either result = await usecase.call(
        param: NotificationsParams(notificationIds: notificationIds),
      );

      if (isClosed) return;

      result.fold(
        (error) {
          _logger.e(
              'Failed to mark notifications as read on server - Error: $error');
          if (originalNotifications.isNotEmpty) {
            _revertMarkManyAsRead(originalNotifications);
          }
        },
        (success) {
          _logger.i(
              '${notificationIds.length} notifications marked as read successfully');
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) return;
      _logger
          .e('Exception while marking notifications as read: $e\n$stackTrace');
      if (originalNotifications.isNotEmpty) {
        _revertMarkManyAsRead(originalNotifications);
      }
    }
  }

  Future<void> deleteNotifications({
    required List<String> notificationIds,
    required Usecase usecase,
  }) async {
    if (isClosed) return;

    _logger.d('Attempting to delete ${notificationIds.length} notifications');

    List<NotificationModel> deletedNotifications = [];
    if (state is NotificationsLoadedState) {
      final currentState = state as NotificationsLoadedState;
      final idSet = notificationIds.toSet();
      deletedNotifications = currentState.allNotifications
          .where((n) => idSet.contains(n.notificationId))
          .toList();
    }

    deleteManyLocally(notificationIds);

    if (isClosed) return;

    try {
      final Either result = await usecase.call(
        param: NotificationsParams(notificationIds: notificationIds),
      );

      if (isClosed) return;

      result.fold(
        (error) {
          _logger.e('Failed to delete notifications on server - Error: $error');
          if (deletedNotifications.isNotEmpty) {
            _revertDeleteMany(deletedNotifications);
          }
        },
        (success) {
          _logger.i(
              '${notificationIds.length} notifications deleted successfully');
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) return;
      _logger.e('Exception while deleting notifications: $e\n$stackTrace');
      if (deletedNotifications.isNotEmpty) {
        _revertDeleteMany(deletedNotifications);
      }
    }
  }

  Future<void> markAllAsRead({
    required Usecase usecase,
  }) async {
    if (isClosed) return;

    _logger.d('Attempting to mark all notifications as read');

    if (state is! NotificationsLoadedState) return;

    final currentState = state as NotificationsLoadedState;
    final unreadIds = currentState.allNotifications
        .where((n) => n.readAt == null)
        .map((n) => n.notificationId)
        .toList();

    if (unreadIds.isEmpty) {
      _logger.d('No unread notifications to mark');
      return;
    }

    await markAsRead(notificationIds: unreadIds, usecase: usecase);
  }

  @override
  Future<void> close() {
    _logger.d('Closing NotificationsCubit');
    return super.close();
  }
}
