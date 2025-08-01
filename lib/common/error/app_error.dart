import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import '../../core/_config/app_config.dart';

class AppError {
  final String? message;
  final List<String>? messages;
  final ErrorType type;
  final Object? originalError;
  final StackTrace? stackTrace;
  final int? status;
  final List<String>? suggestions;

  AppError({
    this.message,
    this.messages,
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

    late final String emoji;

    switch (type) {
      case ErrorType.network:
        emoji = '🌐';
        break;
      case ErrorType.authentication:
        emoji = '🔐';
        break;
      case ErrorType.validation:
        emoji = '🧾';
        break;
      case ErrorType.server:
        emoji = '⚠️';
        break;
      case ErrorType.unknown:
        emoji = '❌';
        break;
      case ErrorType.configuration:
        emoji = '⚙️';
        break;
      case ErrorType.database:
        emoji = '🗄️';
        break;
      case ErrorType.timeout:
        emoji = '⏱️';
        break;
      case ErrorType.canceled:
        emoji = '🚫';
        break;
      case ErrorType.api:
        emoji = '🔗';
        break;
      case ErrorType.notFound:
        emoji = '🔍';
        break;
    }

    // determine what type of messages to log
    final logMessage = messages != null && messages!.isNotEmpty
        ? '$message\nAdditional details: ${messages!.join(', ')}'
        : message;

    logger.e(
      '${emoji} ${type.name}: $logMessage. Error: $originalError\nStackTrace: $stackTrace',
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
      messages: (json['messages'] as List?)?.cast<String>(),
      suggestions: (json['suggestions'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'status': status,
      'message': message,
      'messages': messages,
      'suggestions': suggestions,
    };
  }

  // General factory
  factory AppError.create({
    String? message,
    ErrorType type = ErrorType.unknown,
    Object? originalError,
    List<String>? messages,
    StackTrace? stackTrace,
    shouldLog = true,
  }) {
    final error = AppError(
      message: message,
      messages: messages,
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

  // helpers

  // get all error message
  /*
  Usage:
      error.allMassages
  */
  List<String> get allMessages {
    final result = <String>[];
    if (message != null) {
      result.add(message!);
    }
    if (messages != null && messages!.isNotEmpty) {
      result.addAll(messages!);
    }
    return result;
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
  notFound
}
