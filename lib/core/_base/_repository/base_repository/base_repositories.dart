import 'package:logger/logger.dart';

import '../../../../common/error/app_error.dart';
import '../../../../common/networks/api_client.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../_services/db/database_service.dart';

abstract class BaseRepository {
  final ApiClient _apiClient;
  final DatabaseService _databaseService;
  final Logger _logger;

  BaseRepository({
    ApiClient? apiClient,
    DatabaseService? databaseService,
    Logger? logger,
  })  : _apiClient = apiClient ?? sl<ApiClient>(),
        _databaseService = databaseService ?? sl<DatabaseService>(),
        _logger = logger ?? Logger();

  ApiClient get apiClient => _apiClient;
  DatabaseService get databaseService => _databaseService;
  Logger get logger => _logger;

  // --  METHODS  --
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (error, stackTrace) {
      AppError.create(
        message: 'API Error in ${runtimeType.toString()}',
        type: ErrorType.network,
        originalError: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<T> handleDatabaseOperation<T>(
    Future<T> Function() dbOperation, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(milliseconds: 200),
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await dbOperation();
      } catch (error, stackTrace) {
        attempts++;
        AppError.create(
          message:
              'Database operation failed in ${runtimeType.toString()}, attempt $attempts of $maxRetries',
          type: ErrorType.database,
          originalError: error,
          stackTrace: stackTrace,
        );
        if (attempts == maxRetries) {
          AppError.create(
            message: 'Database operation failed after $maxRetries attempts',
            type: ErrorType.database,
            originalError: error,
            stackTrace: stackTrace,
          );
          rethrow;
        }
        await Future.delayed(retryDelay * attempts);
      }
    }
    throw Exception('Database operation failed after $maxRetries attempts');
  }

  Future<T?> handleCacheOperation<T>(Future<T?> Function() cacheOperation,
      Future<T?> Function() fallbackOperation,
      {bool allowEmpty = false}) async {
    try {
      final result = await cacheOperation();

      if (result == null) {
        return await fallbackOperation();
      }

      final shouldUseResult = allowEmpty || _isNotEmpty(result);

      if (shouldUseResult) {
        return result;
      }

      return await fallbackOperation();
    } catch (error, stackTrace) {
      _logger.w(
        'Cache operation failed in ${runtimeType.toString()}, falling back. Error: $error\nStackTrace: $stackTrace',
      );
      try {
        return await fallbackOperation();
      } catch (fallbackError, fallbackStackTrace) {
        AppError.create(
          message: 'Fallback operation failed in ${runtimeType.toString()}',
          type: ErrorType.database,
          originalError: fallbackError,
          stackTrace: fallbackStackTrace,
        );
        rethrow;
      }
    }
  }

  Future<void> handleSyncOperation(
    Future<void> Function() syncOperation, {
    Future<void> Function()? onConflict,
    Future<void> Function()? onComplete,
  }) async {
    try {
      await syncOperation();
      if (onComplete != null) await onComplete();
    } catch (error, stackTrace) {
      if (error is ConflictException && onConflict != null) {
        _logger.w(
          'Sync conflict detected in ${runtimeType.toString()}, attempting resolution. Error: $error\nStackTrace: $stackTrace',
        );
        try {
          await onConflict();
        } catch (conflictError, conflictStackTrace) {
          AppError.create(
            message: 'Conflict resolution failed in ${runtimeType.toString()}',
            type: ErrorType.database,
            originalError: conflictError,
            stackTrace: conflictStackTrace,
          );
          rethrow;
        }
      } else {
        AppError.create(
          message: 'Sync operation failed in ${runtimeType.toString()}',
          type: ErrorType.database,
          originalError: error,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    }
  }

  Future<void> dispose() async {
    try {
      await _databaseService.close();
    } catch (error, stackTrace) {
      AppError.create(
        message: 'Error disposing repository resources',
        type: ErrorType.database,
        originalError: error,
        stackTrace: stackTrace,
      );
    }
  }

  bool _isNotEmpty<T>(T result) {
    if (result is List) return result.isNotEmpty;
    if (result is Map) return result.isNotEmpty;
    if (result is String) return result.isNotEmpty;
    if (result is Set) return result.isNotEmpty;
    return true;
  }
}

class ConflictException implements Exception {
  final String message;
  final dynamic conflictData;

  ConflictException(this.message, {this.conflictData});

  @override
  String toString() => 'ConflictException: $message';
}
