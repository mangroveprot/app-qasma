import 'package:dartz/dartz.dart';

import '../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../../error/app_error.dart';

part 'button_cubit_state.dart';

class ButtonCubit extends BaseCubit<ButtonState> {
  ButtonCubit() : super(ButtonInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    emit(ButtonLoadingState());
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    emit(ButtonInitialState());
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
            : [message ?? 'Unknown error occurred']);

    emit(
      ButtonFailureState(
        errorMessages: finalErrorMessages,
        suggestions: finalSuggestions,
      ),
    );
  }

  Future<void> execute({dynamic params, required Usecase usecase}) async {
    emitLoading();
    await Future.delayed(const Duration(seconds: 2));
    try {
      final Either result = await usecase.call(param: params);

      result.fold(
        (error) {
          emitError(
            errorMessages: error.messages,
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          emit(ButtonSuccessState(data));
        },
      );
    } catch (e, stackTrace) {
      emitError(
        errorMessages: [e.toString()],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
