import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../core/_config/app_config.dart';
import '../../error/app_error.dart';

class LoggerInterceptor extends InterceptorsWrapper {
  // ignore: unused_field
  final Logger _logger;

  LoggerInterceptor(this._logger)
    : super(
        onRequest: (options, handler) {
          if (AppConfig.shouldShowLogs) {
            final data = options.data;
            String body;

            if (data is FormData) {
              final fields = data.fields
                  .map((f) => '${f.key}: ${f.value}')
                  .join(', ');
              final files = data.files
                  .map((f) => '${f.key}: File(${f.value.filename})')
                  .join(', ');
              body = 'FormData - Fields: {$fields}, Files: {$files}';
            } else {
              body = data.toString();
            }

            _logger.i('''
➜ Request:
- Method: ${options.method}
- URL: ${options.uri}
- Headers: ${options.headers}
- Body: $body
''');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.shouldShowLogs) {
            _logger.i('''
✔ Response:
- URL: ${response.requestOptions.uri}
- Status: ${response.statusCode}
- Data: ${response.data}
''');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (AppConfig.shouldShowLogs) {
            final req = error.requestOptions;
            final res = error.response;
            final data = res?.data;

            _logger.e('''
❌ Error:
- Method: ${req.method}
- URL: ${req.uri}
- Status: ${res?.statusCode ?? 'No Response'}
- Message: ${_getErrorMessage(error)}
- Response: ${_formatResponse(data)}
''');
          }

          AppError.create(
            message: _getErrorMessage(error),
            type: _mapErrorType(error),
            originalError: error,
            stackTrace: error.stackTrace,
          );

          handler.next(error);
        },
      );

  static String _getErrorMessage(DioException error) {
    final data = error.response?.data;

    try {
      if (data is Map<String, dynamic>) {
        final err = data['error'];
        if (err is Map<String, dynamic>) {
          return err['message'] ?? error.message ?? 'Unknown error';
        }
      } else if (data is String) {
        final parsed = json.decode(data);
        if (parsed is Map<String, dynamic>) {
          return parsed['error']?['message'] ?? 'Unknown error';
        }
      }
    } catch (_) {}

    return error.message ?? 'Unknown network error';
  }

  static String _formatResponse(dynamic data) {
    try {
      return const JsonEncoder.withIndent(
        '  ',
      ).convert(data is String ? json.decode(data) : data);
    } catch (_) {
      return data.toString();
    }
  }

  static ErrorType _mapErrorType(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorType.timeout;
      case DioExceptionType.badResponse:
        return ErrorType.server;
      case DioExceptionType.cancel:
        return ErrorType.canceled;
      case DioExceptionType.connectionError:
        return ErrorType.network;
      default:
        return ErrorType.unknown;
    }
  }
}
