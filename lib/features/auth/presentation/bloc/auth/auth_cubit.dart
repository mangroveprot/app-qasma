import '../../../../../common/networks/api_client.dart';
import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  final ApiClient apiClient;

  AuthCubit({required this.apiClient}) : super(const AuthInitialState());

  @override
  void emitLoading({bool isRefreshing = false}) {
    emit(AuthLoadingState(isRefreshing: isRefreshing));
  }

  @override
  void emitInitial({bool isRefreshing = false}) {
    emit(const AuthInitialState());
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
      AuthFailureState(
        errorMessages: finalErrorMessages,
        suggestions: finalSuggestions,
      ),
    );
  }

  Future<void> checkAuth() async {
    emitLoading();
    try {
      final refreshToken = SharedPrefs().getString('refreshToken');

      if (refreshToken != null) {
        final success = await apiClient.refreshToken;
        if (success) {
          emit(const AuthSuccessState());
          return;
        }
      }

      emit(const AuthFailureState(errorMessages: ['Not authenticated']));
    } catch (e, stackTrace) {
      emitError(
        message: 'Authentication check failed',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> logout() async {
    emit(const LogoutLoadingState());
    try {
      await SharedPrefs().clear(); // Clear tokens
      emit(const LogoutSuccessState());
    } catch (e) {
      emit(LogoutFailureState(errorMessages: [e.toString()]));
    }
  }
}
