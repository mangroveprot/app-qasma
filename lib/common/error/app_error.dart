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

  String get userMessage {
    if (shouldIgnoreError()) {
      return '';
    }

    if (message != null && _isUserFriendly(message!)) {
      return message!;
    }

    return _getUserFriendlyMessage();
  }

  bool shouldIgnoreError() {
    if (message != null && message!.toLowerCase().contains('jwt expired')) {
      return true;
    }

    if (messages != null && messages!.isNotEmpty) {
      for (final msg in messages!) {
        if (msg.toLowerCase().contains('jwt expired')) {
          return true;
        }
      }
    }

    return false;
  }

  bool _isUserFriendly(String msg) {
    // check if message contains technical terms that users shouldn't see
    final technicalTerms = [
      'DioException',
      'SocketException',
      'HttpException',
      'TimeoutException',
      'FormatException',
      'package:',
      'StackTrace',
      '#0',
      '#1',
      '#2',
      '#3',
      '#4',
      '#5',
      'dart:',
      '.dart:',
      'Exception',
      'Error:',
      'connection errored',
      'Network is unreachable',
      'most likely cannot be solved by the library',
      'connection timeout',
      'request connection took longer',
      'aborted',
      'RequestOptions',
      'connectTimeout',
      'receiveTimeout',
      'sendTimeout',
      'BadCertificateException',
      'HandshakeException',
      'TlsException',
      'OS Error',
      'errno =',
    ];

    return !technicalTerms
        .any((term) => msg.toLowerCase().contains(term.toLowerCase()));
  }

  /// Generate user-friendly error message based on error type
  String _getUserFriendlyMessage() {
    switch (type) {
      case ErrorType.network:
        return 'Unable to connect to the server. Please check your internet connection and try again.';

      case ErrorType.timeout:
        return 'Connection timeout. Please check your internet connection and try again.';

      case ErrorType.authentication:
        return 'Authentication failed. Please login again.';

      case ErrorType.validation:
        // If we have specific validation messages, return them
        if (messages != null && messages!.isNotEmpty) {
          return messages!.join(', ');
        }
        return 'Please check your input and try again.';

      case ErrorType.server:
        if (status != null) {
          switch (status) {
            case 500:
            case 502:
            case 503:
            case 504:
              return 'Server is currently unavailable. Please try again later.';
            case 429:
              return 'Too many requests. Please wait a moment before trying again.';
            default:
              return 'Server error occurred. Please try again later.';
          }
        }
        return 'Server error occurred. Please try again later.';

      case ErrorType.notFound:
        return 'The requested resource was not found.';

      case ErrorType.canceled:
        return 'Request was cancelled.';

      case ErrorType.api:
        if (message != null && _isUserFriendly(message!)) {
          return message!;
        }
        if (status != null) {
          switch (status) {
            case 400:
              return 'Invalid request. Please check your input.';
            case 401:
              return 'Authentication failed. Please login again.';
            case 403:
              return "Access denied. You don't have permission to perform this action.";
            case 404:
              return 'The requested resource was not found.';
            case 422:
              if (messages != null && messages!.isNotEmpty) {
                return messages!.join(', ');
              }
              return 'Invalid data provided. Please check your input.';
            default:
              return 'Something went wrong. Please try again later.';
          }
        }
        return 'Something went wrong. Please try again later.';

      case ErrorType.database:
        return 'Data access error. Please try again later.';

      case ErrorType.configuration:
        return 'Application configuration error. Please restart the app.';

      case ErrorType.unknown:
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  factory AppError.fromDio(DioException e) {
    final responseData = e.response?.data;

    ErrorType errorType;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorType = ErrorType.timeout;
        break;
      case DioExceptionType.connectionError:
        errorType = ErrorType.network;
        break;
      case DioExceptionType.badResponse:
        // Determine type based on status code
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          errorType = ErrorType.authentication;
        } else if (statusCode == 404) {
          errorType = ErrorType.notFound;
        } else if (statusCode != null && statusCode >= 500) {
          errorType = ErrorType.server;
        } else if (statusCode == 422) {
          errorType = ErrorType.validation;
        } else {
          errorType = ErrorType.api;
        }
        break;
      case DioExceptionType.cancel:
        errorType = ErrorType.canceled;
        break;
      case DioExceptionType.unknown:
      default:
        errorType = ErrorType.network;
        break;
    }

    // Check if it follows your standard error format
    if (responseData is Map<String, dynamic> &&
        responseData['error'] is Map<String, dynamic>) {
      final errorJson = responseData['error'];
      return AppError(
        type: errorType,
        status: errorJson['status'] ?? e.response?.statusCode,
        message: errorJson['message'],
        messages: (errorJson['messages'] as List?)?.cast<String>(),
        suggestions: (errorJson['suggestions'] as List?)?.cast<String>(),
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }

    // Fallback if it's not known format
    return AppError(
      type: errorType,
      message: e.message,
      originalError: e,
      stackTrace: e.stackTrace,
      status: e.response?.statusCode,
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

  // automatic logging
  factory AppError.create({
    String? message,
    ErrorType type = ErrorType.unknown,
    Object? originalError,
    List<String>? messages,
    StackTrace? stackTrace,
    int? status,
    bool shouldLog = true,
  }) {
    final error = AppError(
      message: message,
      messages: messages,
      type: type,
      originalError: originalError,
      stackTrace: stackTrace,
      status: status,
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

  // get all error message (user-friendly)
  /*
  Usage:
      error.allMessages
  */
  List<String> get allMessages {
    final result = <String>[];

    result.add(userMessage);

    if (messages != null && messages!.isNotEmpty) {
      for (final msg in messages!) {
        if (_isUserFriendly(msg) && !result.contains(msg)) {
          result.add(msg);
        }
      }
    }

    return result;
  }

  // get all technical error messages (for debugging)
  /*
  Usage:
      error.allTechnicalMessages
  */
  List<String> get allTechnicalMessages {
    final result = <String>[];
    if (message != null) {
      result.add(message!);
    }
    if (messages != null && messages!.isNotEmpty) {
      result.addAll(messages!);
    }
    return result;
  }

  List<String> get allUserMessages {
    final result = <String>[];

    result.add(userMessage);

    if (messages != null && messages!.isNotEmpty) {
      for (final msg in messages!) {
        if (_isUserFriendly(msg) && !result.contains(msg)) {
          result.add(msg);
        }
      }
    }

    return result;
  }

  List<String> get userSuggestions {
    if (suggestions != null && suggestions!.isNotEmpty) {
      return suggestions!;
    }

    switch (type) {
      case ErrorType.network:
      case ErrorType.timeout:
        return [
          'Check your internet connection',
          'Try again in a few moments',
          "Ensure you're connected to WiFi or mobile data"
        ];

      case ErrorType.authentication:
        return [
          'Please login again',
          'Check your credentials',
          'Contact support if the problem persists'
        ];

      case ErrorType.validation:
        return [
          'Check all required fields',
          'Ensure data format is correct',
          'Try again with valid information'
        ];

      case ErrorType.server:
        return [
          'Try again later',
          'Check if the service is available',
          'Contact support if the problem continues'
        ];

      default:
        return [
          'Try again later',
          'Restart the app if needed',
          'Contact support if the issue persists'
        ];
    }
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
