import 'package:dartz/dartz.dart';
import '../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../../error/app_error.dart';

part 'button_cubit_state.dart';

class ButtonCubit extends BaseCubit<ButtonState> {
  ButtonCubit() : super(ButtonInitialState());

  @override
  void emitLoading({bool isRefreshing = false, String? buttonId}) {
    emit(ButtonLoadingState(buttonId));
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

  Future<void> execute(
      {dynamic params, required Usecase usecase, String? buttonId}) async {
    emit(ButtonLoadingState(buttonId));
    await Future.delayed(const Duration(seconds: 2));

    try {
      final Either result = await usecase.call(param: params);

      result.fold(
        (error) {
          emit(ButtonFailureState(
            errorMessages: error.allUserMessages,
            suggestions: error.userSuggestions,
            buttonId: buttonId,
          ));
        },
        (data) {
          emit(ButtonSuccessState(data, buttonId));
        },
      );
    } catch (e) {
      emit(ButtonFailureState(
        errorMessages: [e.toString()],
        buttonId: buttonId,
      ));
    }
  }
}
