import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import '../../core/_config/app_config.dart';

class AppError {
  final String message;
  final ErrorType type;
  final Object? originalError;
  final StackTrace? stackTrace;
  final int? status;
  final List<String>? suggestions;

  AppError({
    required this.message,
    required this.type,
    this.originalError,
    this.stackTrace,
    this.status,
    this.suggestions,
  });

  void log() {
    if (!AppConfig.shouldShowLogs) return;

    final logger = Logger(
      printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
    );

    final emoji = switch (type) {
      ErrorType.network => '🌐',
      ErrorType.authentication => '🔐',
      ErrorType.validation => '🧾',
      ErrorType.server => '⚠️',
      _ => '❌',
    };

    logger.e(
      '$emoji ${type.name}: $message',
      error: originalError,
      stackTrace: stackTrace,
    );

    // if (kDebugMode) {
    //   debugPrint('Error: $message');
    // }
  }

  /// Create error from DioException
  factory AppError.fromDio(DioException e) {
    final responseData = e.response?.data;

    // Check if it follows your standard error format
    if (responseData is Map<String, dynamic> &&
        responseData['error'] is Map<String, dynamic>) {
      final errorJson = responseData['error'];
      return AppError.fromJson(errorJson);
    }

    // Fallback if it's not your known format
    return AppError(
      type: ErrorType.network,
      message: e.message ?? 'Network error occurred',
      originalError: e,
      stackTrace: e.stackTrace,
    );
  }

  factory AppError.fromJson(Map<String, dynamic> json) {
    return AppError(
      type: ErrorType.api,
      status: json['status'],
      message: json['message'] ?? 'Unknown API error',
      suggestions: (json['suggestions'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'status': status,
      'message': message,
      'suggestions': suggestions,
    };
  }

  // General factory
  factory AppError.create({
    required String message,
    ErrorType type = ErrorType.unknown,
    Object? originalError,
    StackTrace? stackTrace,
    shouldLog = true,
  }) {
    final error = AppError(
      message: message,
      type: type,
      originalError: originalError,
      stackTrace: stackTrace,
    );

    if (shouldLog) {
      error.log();
    }
    return error;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ErrorType {
  network,
  authentication,
  validation,
  server,
  unknown,
  configuration,
  database,
  timeout,
  canceled,
  api,
}
