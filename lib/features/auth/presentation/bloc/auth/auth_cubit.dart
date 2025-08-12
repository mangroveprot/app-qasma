import 'package:dartz/dartz.dart';

import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_services/db/database_service.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../../core/_usecase/usecase.dart';
import '../../../../../infrastructure/injection/service_locator.dart';
import '../../../data/models/logout_params.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  static AuthCubit? _instance;
  static bool _isAutoLoggingOut = false;

  AuthCubit() : super(const AuthInitialState());

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

  Future<void> logout({
    bool isAutoLogout = false,
    required Usecase usecase,
    required LogoutParams params,
  }) async {
    emit(LogoutLoadingState(isAutoLogout: isAutoLogout));
    try {
      final Either result = await usecase.call(param: params);

      result.fold(
        (error) {
          emit(LogoutFailureState(
            errorMessages: error.allUserMessages,
            suggestions: error.userSuggestions,
          ));
        },
        (data) async {
          await _clearAuthData();

          emit(LogoutSuccessState(isAutoLogout: isAutoLogout));
        },
      );
    } catch (e) {
      emit(LogoutFailureState(
        errorMessages: [e.toString()],
        isAutoLogout: isAutoLogout,
      ));
    }
  }

  Future<void> performAutoLogout({String? reason}) async {
    if (_isAutoLoggingOut || state is AutoLogoutState) {
      return;
    }

    _isAutoLoggingOut = true;
    try {
      await _clearAuthData();

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

  bool get isAuthenticated {
    final refreshToken = SharedPrefs().getString('refreshToken');
    final currentUserId = SharedPrefs().getString('currentUserId');
    return refreshToken != null && currentUserId != null;
  }

  void resetToInitial() {
    emit(const AuthInitialState());
  }

  @override
  Future<void> close() {
    if (_instance == this) {
      return Future.value();
    }
    return super.close();
  }
}
