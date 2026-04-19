import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../data/models/activity_log_model.dart';
import '../../data/models/activity_logs_page_result.dart';
import '../../domain/entities/activity_log.dart';

part 'activity_logs_cubit_state.dart';

class ActivityLogsCubit extends BaseCubit<ActivityLogsCubitState> {
  final Logger _logger = Logger();

  ActivityLogsCubit() : super(ActivityLogsInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(ActivityLogsLoadingState(isRefreshing: isRefreshing));
    }
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    if (!isClosed) {
      emit(ActivityLogsInitialState());
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
            : [message ?? 'Failed to load activity logs']);

    emit(
      ActivityLogsFailureState(
        errorMessages: finalErrorMessages,
        suggestions: finalSuggestions,
      ),
    );
  }

  Future<void> loadActivityLogs({
    dynamic params,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    if (isClosed) {
      _logger.d('Cubit closed, skipping loadActivityLogs');
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
          _logger.e('Failed to load activity logs: $error');
          emitError(
            errorMessages: error.messages ?? ['Failed to load activity logs'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          if (isClosed) {
            _logger.d('Cubit closed in fold success callback');
            return;
          }
          final pageResult = data as ActivityLogsPageResult;
          final logs = pageResult.logs;
          _logger.i(
              'Successfully loaded ${logs.length} activity logs (page ${pageResult.page})');
          emit(
            ActivityLogsLoadedState(
              activityLogs: logs,
              page: pageResult.page,
              limit: pageResult.limit,
              total: pageResult.total,
              hasMore: pageResult.hasMore,
              searchTerm: pageResult.searchTerm,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) {
        _logger.d('Cubit closed in catch block');
        return;
      }
      _logger.e('Error loading activity logs: $e\n$stackTrace');
      emitError(
        errorMessages: ['Failed to load activity logs: ${e.toString()}'],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> refreshActivityLogs({
    dynamic params,
    required Usecase usecase,
  }) async {
    if (isClosed) return;
    _logger.d('Refreshing activity logs');
    await loadActivityLogs(
      params: params,
      usecase: usecase,
      isRefreshing: true,
    );
  }

  Future<void> loadMore({
    required Usecase usecase,
  }) async {
    if (isClosed) return;
    if (state is! ActivityLogsLoadedState) return;

    final currentState = state as ActivityLogsLoadedState;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    final nextPage = currentState.page + 1;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final Either result = await usecase.call(param: {
        'page': nextPage,
        'limit': currentState.limit,
        'searchTerm': currentState.searchTerm,
        'forceRefresh': false,
      });

      if (isClosed) return;

      result.fold(
        (error) {
          _logger.e('Failed to load more activity logs: $error');
          emitError(
            errorMessages:
                error.messages ?? ['Failed to load more activity logs'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          if (isClosed) return;
          final pageResult = data as ActivityLogsPageResult;
          final newLogs = List<ActivityLogModel>.from(currentState.activityLogs)
            ..addAll(pageResult.logs);

          emit(
            currentState.copyWith(
              activityLogs: newLogs,
              page: pageResult.page,
              total: pageResult.total,
              hasMore: pageResult.hasMore,
              isLoadingMore: false,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      if (isClosed) return;
      _logger.e('Error loading more activity logs: $e\n$stackTrace');
      emitError(
        errorMessages: ['Failed to load more activity logs: ${e.toString()}'],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> close() {
    _logger.d('Closing ActivityLogsCubit');
    return super.close();
  }
}
