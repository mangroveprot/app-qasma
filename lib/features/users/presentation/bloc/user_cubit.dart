import 'package:dartz/dartz.dart';

import '../../../../common/error/app_error.dart';
import '../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../core/_usecase/usecase.dart';
import '../../data/models/user_model.dart';

part 'user_cubit_state.dart';

class UserCubit extends BaseCubit<UserCubitState> {
  UserCubit() : super(UserInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    emit(UserLoadingState(isRefreshing: isRefreshing));
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    emit(UserInitialState());
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
            : [message ?? 'Failed to load user']);

    emit(
      UserFailureState(
        errorMessages: finalErrorMessages,
        suggestions: finalSuggestions,
      ),
    );
  }

  // Load user by idNumber (idNumber or email)
  Future<void> loadUser({
    required String idNumber,
    required Usecase usecase,
    bool isRefreshing = false,
  }) async {
    emitLoading(isRefreshing: isRefreshing);

    try {
      final Either result = await usecase.call(param: idNumber);

      result.fold(
        (error) {
          emitError(
            errorMessages: error.messages ?? ['Failed to load user'],
            suggestions: error.suggestions,
            error: error,
          );
        },
        (data) {
          final UserModel user = data as UserModel;
          emit(UserLoadedState(user));
        },
      );
    } catch (e, stackTrace) {
      emitError(
        errorMessages: ['Failed to load user: ${e.toString()}'],
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Refresh user data
  Future<void> refreshUser({
    required String idNumber,
    required Usecase usecase,
  }) async {
    await loadUser(
      idNumber: idNumber,
      usecase: usecase,
      isRefreshing: true,
    );
  }

  // Clear user data
  void clearUser() {
    emit(UserInitialState());
  }
}
