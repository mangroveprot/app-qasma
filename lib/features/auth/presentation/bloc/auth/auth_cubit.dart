import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../../../core/_base/_bloc_cubit/base_cubit.dart';
import '../../../../../common/error/app_error.dart';
import '../../../../../core/_base/_services/db/database_service.dart';
import '../../../../../core/_base/_services/fcm/fcm_service.dart';
import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../../core/_usecase/usecase.dart';
import '../../../../../infrastructure/injection/service_locator.dart';
import '../../../../users/data/models/params/dynamic_param.dart';
import '../../../../users/domain/usecases/save_fcm_token_usecase.dart';
import '../../../data/models/logout_params.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends BaseCubit<AuthState> {
  static AuthCubit? _instance;
  static bool _isAutoLoggingOut = false;
  Logger logger = sl<Logger>();

  StreamSubscription<String>? _fcmTokenSubscription;
  Timer? _fcmRetryTimer;
  int _fcmRetryAttempts = 0;
  static const int _maxFcmRetries = 3;

  AuthCubit() : super(const AuthInitialState()) {
    _listenToFCMTokenChanges();
  }

  static AuthCubit get instance {
    _instance ??= AuthCubit();
    return _instance!;
  }

  // listen to fcm token changes and auto save
  void _listenToFCMTokenChanges() {
    _fcmTokenSubscription = sl<FCMService>().tokenStream.listen(
      (token) {
        if (isAuthenticated) {
          logger.i('FCM token changed, saving to backend...');
          _saveFCMToken(token);
        }
      },
      onError: (error) {
        logger.e('FCM token stream error: $error');
      },
    );
  }

  // save fcm token afer login
  Future<void> initializeFCMAfterLogin() async {
    try {
      logger.i('Initializing FCM after login...');

      await Future.delayed(const Duration(milliseconds: 300));

      final token = await sl<FCMService>().getToken();

      if (token != null && token.isNotEmpty) {
        await _saveFCMToken(token);
      } else {
        logger.w('FCM token is null, scheduling retry...');
        _scheduleTokenRetry();
      }
    } catch (e) {
      logger.e('Error initializing FCM: $e');
      _scheduleTokenRetry();
    }
  }

  Future<void> _saveFCMToken(String token) async {
    if (!isAuthenticated) {
      logger.w('User not authenticated, skipping FCM token save');
      return;
    }

    try {
      final usecase = sl<SaveFcmTokenUsecase>();
      final params = DynamicParam(fields: {'fcmToken': token});

      final result = await usecase.call(param: params);

      result.fold(
        (error) {
          logger.e('Failed to save FCM token: ${error.allUserMessages}');

          if (_fcmRetryAttempts < _maxFcmRetries) {
            _scheduleTokenRetry(token: token);
          } else {
            logger.e('Max FCM retry attempts reached');
          }
        },
        (success) {
          logger.i('FCM token saved successfully');
          _fcmRetryAttempts = 0;
          _fcmRetryTimer?.cancel();
        },
      );
    } catch (e) {
      logger.e('Exception while saving FCM token: $e');

      if (_fcmRetryAttempts < _maxFcmRetries) {
        _scheduleTokenRetry(token: token);
      }
    }
  }

  void _scheduleTokenRetry({String? token}) {
    _fcmRetryAttempts++;
    final delaySeconds = _fcmRetryAttempts * 10; // 10s, 20s, 30s

    logger.i(
      'Scheduling FCM retry #$_fcmRetryAttempts in ${delaySeconds}s',
    );

    _fcmRetryTimer?.cancel();
    _fcmRetryTimer = Timer(
      Duration(seconds: delaySeconds),
      () async {
        if (!isAuthenticated) return;

        if (token != null) {
          await _saveFCMToken(token);
        } else {
          final newToken = await sl<FCMService>().getToken();
          if (newToken != null) {
            await _saveFCMToken(newToken);
          }
        }
      },
    );
  }

  // invalidate fcm token
  Future<void> _cleanupFCMToken() async {
    try {
      await sl<FCMService>().deleteToken();
      _fcmRetryTimer?.cancel();
      _fcmRetryAttempts = 0;
      logger.i('FCM token cleaned up');
    } catch (e) {
      logger.e('Error cleaning up FCM token: $e');
    }
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

        await initializeFCMAfterLogin();
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
      await _cleanupFCMToken();

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
      await _cleanupFCMToken();

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
    } finally {
      _isAutoLoggingOut = false;
    }
  }

  Future<void> _clearAuthData() async {
    await SharedPrefs().clear();
    await sl<DatabaseService>().dropDatabase();
  }

  void resetToInitial() {
    emit(const AuthInitialState());
  }

  bool get isAuthenticated {
    final refreshToken = SharedPrefs().getString('refreshToken');
    final currentUserId = SharedPrefs().getString('currentUserId');
    return refreshToken != null && currentUserId != null;
  }

  @override
  Future<void> close() {
    _fcmTokenSubscription?.cancel();
    _fcmRetryTimer?.cancel();

    if (_instance == this) {
      return Future.value();
    }

    return super.close();
  }
}
