import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../data/models/activity_log_model.dart';
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
          final List<ActivityLogModel> activityLogs =
              data as List<ActivityLogModel>;
          _logger.i('Successfully loaded ${activityLogs.length} activity logs');
          emit(ActivityLogsLoadedState(activityLogs));
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

  @override
  Future<void> close() {
    _logger.d('Closing ActivityLogsCubit');
    return super.close();
  }
}
