import 'dart:async';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../_config/app_config.dart';
import '../../../../common/error/app_error.dart';
import '../../_models/table_model.dart';

class DatabaseService {
  static final _databaseName = AppConfig.databaseName;
  static final _databaseVersion = AppConfig.dbVersion;

  final Logger _logger = Logger();

  Database? _database;

  final List<TableModel> _schemas;

  DatabaseService(this._schemas);

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      final path = join(await getDatabasesPath(), _databaseName);
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: onDatabaseDowngradeDelete,
      );
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to initialize database',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    try {
      await db.transaction((txn) async {
        for (final schema in _schemas) {
          await txn.execute(schema.createTableQuery);
          for (final index in schema.createIndexes) {
            await txn.execute(index);
          }
        }
        _logger.i('All database tables created successfully.');
      });
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to create tables',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      await db.transaction((txn) async {
        if (oldVersion < 2) {
          // Future migrations here
        }
      });
      _logger.i('Database upgraded from $oldVersion to $newVersion');
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to upgrade database from $oldVersion to $newVersion',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Retry wrapper
  Future<T> _withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e, stackTrace) {
        attempts++;
        if (attempts == maxRetries) {
          throw AppError.create(
            message: 'Database operation failed after $maxRetries attempts',
            type: ErrorType.database,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
        await Future.delayed(Duration(milliseconds: 200 * attempts));
        AppError.create(
          message: 'Retrying database operation, attempt $attempts',
          type: ErrorType.database,
          originalError: e,
          stackTrace: stackTrace,
          shouldLog: false,
        );
      }
    }
    throw AppError.create(
      message: 'Unexpected error in database retry mechanism',
      type: ErrorType.database,
    );
  }

  // Batch execution
  Future<void> runBatch(void Function(Batch batch) operations) async {
    final db = await database;
    await _withRetry(() async {
      final batch = db.batch();
      operations(batch);
      await batch.commit(noResult: true);
    });
  }

  // Transaction execution
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    final db = await database;
    return await _withRetry(() => db.transaction(action));
  }

  // Drop the entire database
  Future<void> dropDatabase() async {
    try {
      await close();

      final path = join(await getDatabasesPath(), _databaseName);

      // Delete the database file
      await deleteDatabase(path);

      _logger.i('Database $_databaseName dropped successfully');
    } catch (e, stackTrace) {
      throw AppError.create(
        message: 'Failed to drop database',
        type: ErrorType.database,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
