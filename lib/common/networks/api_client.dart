import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../core/_config/app_config.dart';
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
      ),
    ]);
  }

  String getBaseUrl() => _urlProvider.baseURL + _urlProvider.apiPath;

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = SharedPrefs().getString('refreshToken');
      if (refreshToken == null) return false;

      final response = await _dio.post(
        _urlProvider.refreshTokenUrl,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        await SharedPrefs().setString('accessToken', newAccessToken);
        return true;
      }
    } catch (e, stack) {
      AppError.create(
        message: 'Failed to refresh token',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: stack,
      );
    }
    return false;
  }

  void _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) {
    final int retries = requestOptions.extra['retries'] ?? 0;
    if (retries < maxRetries) {
      requestOptions.extra['retries'] = retries + 1;
      Future.delayed(
        const Duration(milliseconds: AppConfig.retryDelay),
        () => _dio
            .fetch(requestOptions)
            .then(
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

  // shared error handling logic
  Never _handleDioError(String action, String endpoint, DioException e) {
    final appError =
        e.error is AppError ? e.error as AppError : AppError.fromDioError(e);

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
      _handleDioError('GET', endpoint, e);
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
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, requiresAuth),
      );
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
    return (options ?? Options()).copyWith(
      extra: {...?options?.extra, 'requiresAuth': requiresAuth},
    );
  }
}
