import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dart:async';

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

    _dio.options.validateStatus = (status) {
      return status != null && status < 500;
    };

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

  Completer<bool>? _refreshCompleter;

  Future<bool> _refreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer();

    try {
      final refreshToken = SharedPrefs().getString('refreshToken');
      if (refreshToken == null) {
        _refreshCompleter!.complete(false);
        _refreshCompleter = null;
        return false;
      }

      final response = await _dio.post(
        _urlProvider.refreshTokenUrl,
        data: {'refreshToken': refreshToken},
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

        _refreshCompleter!.complete(true);
        return true;
      } else {
        _refreshCompleter!.complete(false);
        return false;
      }
    } catch (e) {
      _refreshCompleter!.complete(false);
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

  // shared error handling logic
  Never _handleDioError(String action, String endpoint, DioException e) {
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
      final response = await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
          extra: {'requiresAuth': requiresAuth},
        ),
      );

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
}
