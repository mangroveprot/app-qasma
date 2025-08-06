import 'package:dartz/dartz.dart';

import '../../../../../common/error/app_error.dart';
import '../../../../../common/manager/slot_manager.dart';
import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../core/_usecase/usecase.dart';

part 'slots_cubit_state.dart';

class SlotsCubit extends BaseCubit<SlotsCubitState> {
  SlotsCubit() : super(SlotsInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    emit(SlotsLoadingState(isRefreshing: isRefreshing));
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    emit(SlotsInitialState());
  }

  @override
  void emitError({
    String? message,
    List<String>? errorMessages,
    dynamic error,
    StackTrace? stackTrace,
    List<String>? suggestions,
  }) {
    final List<String> finalSuggestions =
        error is AppError ? error.suggestions ?? [] : [];

    final List<String> finalErrorMessages = errorMessages ??
        (error is AppError
            ? error.allMessages
            : [message ?? 'Failed to load slots']);

    emit(SlotsFailureState(
      errorMessages: finalErrorMessages,
      suggestions: finalSuggestions,
    ));
  }

  // Load available slots
  Future<void> loadSlots({
    required String duration,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    emitLoading(isRefreshing: isRefreshing);

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final Either result = await usecase.call(param: duration);

      result.fold(
        (error) {
          emitError(
            errorMessages: error.messages ?? ['Failed to load slots'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          final formattedSlots = SlotManager.formatSlotsForDropdown(data);

          emit(SlotsLoadedState(
            slots: data,
            formattedSlots: formattedSlots,
          ));
        },
      );
    } catch (e, stackTrace) {
      emitError(
        errorMessages: ['Unexpected error: ${e.toString()}'],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
