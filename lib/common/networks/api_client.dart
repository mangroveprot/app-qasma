import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dart:async';

import '../../core/_config/app_config.dart';
import '../../features/auth/presentation/bloc/auth/auth_cubit.dart';
import '../error/app_error.dart';
import '../../core/_base/_services/storage/shared_preference.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/headers_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import '../../core/_config/url_provider.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;
  final int maxRetries;
  final URLProviderConfig _urlProvider;

  static bool _isLoggingOut = false;
  Completer<bool>? _refreshCompleter;

  ApiClient({this.maxRetries = AppConfig.maxRetries})
      : _dio = Dio(),
        _logger = Logger(),
        _urlProvider = URLProviderConfig() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(
      milliseconds: AppConfig.connectTimeout,
    );
    _dio.options.receiveTimeout = const Duration(
      milliseconds: AppConfig.receiveTimeout,
    );
    _dio.options.sendTimeout = const Duration(
      milliseconds: AppConfig.sendTimeout,
    );

    _dio.interceptors.addAll([
      HeadersInterceptor(),
      LoggerInterceptor(_logger),
      AuthInterceptor(
        dio: _dio,
        urlProvider: _urlProvider,
        logger: _logger,
        maxRetries: maxRetries,
        onRefreshToken: _refreshToken,
        retryRequest: _retryRequest,
        onLogout: _performAutoLogout,
      ),
    ]);
  }

  String getBaseUrl() => _urlProvider.baseURL + _urlProvider.apiPath;

  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    if (_isLoggingOut) {
      _logger.w('Already logging out, skipping token refresh');
      return false;
    }

    _refreshCompleter = Completer();

    try {
      final refreshToken = SharedPrefs().getString('refreshToken');
      if (refreshToken == null) {
        _logger.w('No refresh token found');
        _refreshCompleter!.complete(false);
        await _performAutoLogout('No refresh token available');
        return false;
      }

      final response = await _dio.post(
        _urlProvider.refreshTokenUrl,
        data: {'refreshToken': refreshToken},
        options: Options(
          extra: {'requiresAuth': false},
        ),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['document'] != null &&
          response.data['document']['token'] != null) {
        final tokens = response.data['document']['token'];
        final newAccessToken = tokens['access'];
        final newRefreshToken = tokens['refresh'];

        await SharedPrefs().setString('accessToken', newAccessToken);
        await SharedPrefs().setString('refreshToken', newRefreshToken);

        _logger.i('Tokens refreshed successfully');
        _refreshCompleter!.complete(true);
        return true;
      } else {
        _logger.w('Token refresh failed: Invalid response');
        _refreshCompleter!.complete(false);
        await _performAutoLogout('Token refresh failed');
        return false;
      }
    } catch (e) {
      _logger.e('Token refresh failed: $e');
      _refreshCompleter!.complete(false);

      if (!_isLoggingOut) {
        if (e is DioException && e.response?.statusCode == 401) {
          _logger.w('Refresh token expired, performing auto logout');
          await _performAutoLogout('Refresh token expired');
        } else {
          _logger.w(
              'Token refresh failed due to network/server error, not logging out');
        }
      }

      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<bool> get refreshToken => _refreshToken();

  void _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) {
    final int retries = requestOptions.extra['retries'] ?? 0;
    if (retries < maxRetries) {
      requestOptions.extra['retries'] = retries + 1;
      Future.delayed(
        const Duration(milliseconds: AppConfig.retryDelay),
        () => _dio.fetch(requestOptions).then(
              (response) => handler.resolve(response),
              onError: (e) => handler.reject(e),
            ),
      );
    } else {
      AppError.create(
        message: 'Max retries reached for ${requestOptions.uri}',
        type: ErrorType.network,
      );
      handler.reject(
        DioException(
          requestOptions: requestOptions,
          error: 'Max retries reached',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  Never _handleDioError(String action, String endpoint, DioException e) {
    final requiresAuth = e.requestOptions.extra['requiresAuth'] ?? true;

    if (e.response?.statusCode == 401 && !requiresAuth) {
      final appError = AppError.fromDio(e);
      throw appError;
    }

    if (e.response?.statusCode == 401) {
      throw e;
    }

    final appError =
        e.error is AppError ? e.error as AppError : AppError.fromDio(e);

    throw appError;
  }

  // METHODS
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      throw _handleDioError('GET', endpoint, e);
    }
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post<T>(endpoint,
          data: data,
          queryParameters: queryParameters,
          options: _mergeOptions(options, requiresAuth));

      return response;
    } on DioException catch (e) {
      _handleDioError('POST', endpoint, e);
    }
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      _handleDioError('PUT', endpoint, e);
    }
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      _handleDioError('DELETE', endpoint, e);
    }
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    try {
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
    } on DioException catch (e) {
      _handleDioError('PATCH', endpoint, e);
    }
  }

  Options _mergeOptions(Options? options, bool requiresAuth) {
    final baseOptions = options ?? Options();

    return baseOptions.copyWith(
      extra: {...?baseOptions.extra, 'requiresAuth': requiresAuth},
      validateStatus: baseOptions.validateStatus ?? _dio.options.validateStatus,
    );
  }

  Future<void> _performAutoLogout([String? reason]) async {
    if (_isLoggingOut) {
      _logger.w('Auto logout already in progress, skipping');
      return;
    }

    _isLoggingOut = true;

    try {
      _logger.i('Performing auto logout: ${reason ?? 'Session expired'}');
      await AuthCubit.instance.performAutoLogout(reason: reason);
    } catch (e) {
      _logger.e('Error during auto logout: $e');
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        _isLoggingOut = false;
      });
    }
  }

  static void resetLogoutFlag() {
    _isLoggingOut = false;
  }
}
