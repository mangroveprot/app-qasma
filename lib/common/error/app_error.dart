import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import '../../core/_config/app_config.dart';

class AppError {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;
  final ErrorType type;
  final List<dynamic>? suggestions;

  AppError({
    required this.message,
    this.originalError,
    this.stackTrace,
    this.type = ErrorType.unknown,
    this.suggestions,
  });

  void log() {
    if (AppConfig.shouldShowLogs) {
      final logger = Logger(
        printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
      );

      switch (type) {
        case ErrorType.network:
          logger.e(
            '🌐 Network Error: $message',
            error: originalError,
            stackTrace: stackTrace,
          );
          break;
        case ErrorType.authentication:
          logger.e(
            '🔐 Authentication Error: $message',
            error: originalError,
            stackTrace: stackTrace,
          );
          break;
        case ErrorType.validation:
          logger.w(
            '🧾 Validation Error: $message',
            error: originalError,
            stackTrace: stackTrace,
          );
          break;
        default:
          logger.e(
            '❌ Unknown Error: $message',
            error: originalError,
            stackTrace: stackTrace,
          );
      }

      if (originalError is DioException) {
        final dioErr = originalError as DioException;
        final req = dioErr.requestOptions;
        final path = '${req.baseUrl}${req.path}';

        logger.i('➡️ ${req.method} request ==> $path');
        logger.d('🔎 Error Type: ${dioErr.type}');
        logger.d('💬 Error Message: ${dioErr.message}');
      }

      if (kDebugMode) {
        debugPrint('Error: $message');
      }
    }
  }

  factory AppError.fromException(dynamic exception) {
    if (exception is NetworkException) {
      return AppError(
        message: exception.message,
        type: ErrorType.network,
        stackTrace: exception.stackTrace,
      );
    }

    return AppError(message: exception.toString(), type: ErrorType.unknown);
  }

  factory AppError.fromDioError(DioException dioException, {String? message}) {
    String defaultMessage = 'Unexpected error occurred';
    List<String> suggestions = [];

    try {
      final data = dioException.response?.data;
      if (data is Map<String, dynamic> &&
          data['error'] is Map<String, dynamic>) {
        final errorData = data['error'];
        final apiMessage = errorData['message'];
        final apiSuggestions = errorData['suggestions'];

        if (apiMessage is String && apiMessage.trim().isNotEmpty) {
          defaultMessage = apiMessage;
        }

        if (apiSuggestions is List) {
          suggestions = List<String>.from(apiSuggestions);
        }
      } else if (data is Map<String, dynamic> && data['message'] is String) {
        defaultMessage = data['message'];
      }
    } catch (e) {}

    // fallback if no message is parsed
    defaultMessage = message ?? defaultMessage;

    final error = AppError(
      message: defaultMessage,
      type: ErrorType.network,
      stackTrace: dioException.stackTrace,
      originalError: dioException,
      suggestions: suggestions,
    );

    error.log();
    return error;
  }

  static AppError create({
    required String message,
    ErrorType type = ErrorType.unknown,
    Object? originalError,
    StackTrace? stackTrace,
    bool shouldLog = true,
  }) {
    String finalMessage = message;
    List<dynamic>? suggestions;

    if (originalError is DioException) {
      final data = originalError.response?.data;

      if (data is Map && data['error'] is Map) {
        final errorData = data['error'] as Map;

        if (errorData['message'] is String) {
          finalMessage = errorData['message'];
        }

        if (errorData['suggestions'] is List) {
          suggestions = errorData['suggestions'];
        }
      }
    }

    final error = AppError(
      message: finalMessage,
      type: type,
      originalError: originalError,
      stackTrace: stackTrace,
      suggestions: suggestions,
    );

    if (shouldLog) {
      error.log();
    }

    return error;
  }
}

enum ErrorType {
  network,
  authentication,
  validation,
  unknown,
  database,
  configuration,
  canceled,
  server,
  timeout,
}

class NetworkException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  NetworkException(this.message, {this.stackTrace});
}
