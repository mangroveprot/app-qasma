import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/error/app_error.dart';

part 'base_cubit_state.dart';

abstract class BaseCubit<T extends BaseState> extends Cubit<T> {
  bool _isDisposed = false;

  BaseCubit(T initialState) : super(initialState);

  // loading state
  void emitLoading({bool isRefreshing = false}) {
    emit(LoadingState(isRefreshing: isRefreshing) as T);
  }

  void emitInitial() {
    emit(const InitialState() as T);
  }

  void emitError({
    String? message,
    List<String>? errorMessages,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    AppError(
      message: message,
      originalError: error,
      stackTrace: stackTrace,
      type: ErrorType.unknown,
    );

    emit(
      ErrorState(
        message: message,
        errorMessages: errorMessages,
        error: error,
        stackTrace: stackTrace,
      ) as T,
    );
  }

  @override
  Future<void> close() async {
    if (!_isDisposed) {
      _isDisposed = true;
      await super.close();
    }
  }

  bool get isDisposed => _isDisposed;
}
