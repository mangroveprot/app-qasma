import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_services/db/database_service.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../../infrastructure/injection/service_locator.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  static AuthCubit? _instance;
  static bool _isAutoLoggingOut = false;

  AuthCubit() : super(const AuthInitialState());

  // Singleton pattern to access from anywhere (especially ApiClient)
  static AuthCubit get instance {
    _instance ??= AuthCubit();
    return _instance!;
  }

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
      final currentUserId = SharedPrefs().getString('currentUserId');

      if (refreshToken != null && currentUserId != null) {
        emit(const AuthSuccessState(operation: 'checkAuth'));
      } else {
        emit(const AuthFailureState(
          errorMessages: ['Not authenticated'],
          operation: 'checkAuth',
        ));
      }
    } catch (e, stackTrace) {
      emitError(
        message: 'Authentication check failed',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> logout({bool isAutoLogout = false}) async {
    emit(LogoutLoadingState(isAutoLogout: isAutoLogout));
    try {
      // Clear all stored data
      await _clearAuthData();

      emit(LogoutSuccessState(isAutoLogout: isAutoLogout));
    } catch (e) {
      emit(LogoutFailureState(
        errorMessages: [e.toString()],
        isAutoLogout: isAutoLogout,
      ));
    }
  }

  // Auto logout method called by ApiClient
  Future<void> performAutoLogout({String? reason}) async {
    if (_isAutoLoggingOut || state is AutoLogoutState) {
      return;
    }

    _isAutoLoggingOut = true;
    try {
      // Clear stored data immediately
      await _clearAuthData();

      // Emit auto logout state
      emit(AutoLogoutState(
        reason: reason ?? 'Session expired',
        errorMessages: [reason ?? 'Session expired'],
      ));
    } catch (e) {
      emit(LogoutFailureState(
        errorMessages: ['Auto logout failed: ${e.toString()}'],
        isAutoLogout: true,
      ));
    }
  }

  Future<void> _clearAuthData() async {
    await SharedPrefs().clear();

    await sl<DatabaseService>().dropDatabase();
  }

  // Method to check if user is authenticated
  bool get isAuthenticated {
    final refreshToken = SharedPrefs().getString('refreshToken');
    final currentUserId = SharedPrefs().getString('currentUserId');
    return refreshToken != null && currentUserId != null;
  }

  // Reset to initial state (useful after handling auto logout)
  void resetToInitial() {
    emit(const AuthInitialState());
  }

  // Override close to prevent singleton from being closed
  @override
  Future<void> close() {
    // Don't close the singleton instance
    if (_instance == this) {
      return Future.value();
    }
    return super.close();
  }
}
