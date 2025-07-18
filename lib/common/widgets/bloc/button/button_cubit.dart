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
  void emitError({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
    List<String>? suggestions,
  }) {
    final List<String> finalSuggestions =
        error is AppError ? error.suggestions ?? [] : [];

    emit(
      ButtonFailureState(errorMessage: message, suggestions: finalSuggestions),
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
            message: error.message,
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          emit(ButtonSuccessState());
        },
      );
    } catch (e) {
      emitError(message: e.toString(), error: e);
    }
  }
}
