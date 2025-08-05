import 'package:sqflite/sqflite.dart';

import '../../../../common/error/app_error.dart';
import '../base_repository/base_repositories.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> map);
typedef ToJson<T> = Map<String, dynamic> Function(T model);

class LocalRepository<T> extends BaseRepository {
  final String tableName;
  final String keyField;
  final FromJson<T> fromDb;
  final ToJson<T> toDb;
  LocalRepository({
    required this.tableName,
    required this.keyField, //// e.g. "idNumber", "appointmentId"
    required this.fromDb,
    required this.toDb,
    super.databaseService,
    super.logger,
  });

  Future<T?> getItemById(dynamic id) async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;

      final result = await db.query(
        tableName,
        where: '$keyField = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) return null;

      try {
        final item = fromDb(result.first);
        return item;
      } catch (e) {
        rethrow;
      }
    });
  }

  // getAll()
  Future<List<T>> getAllItems() async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final results = await db.query(tableName);
      return results.map(fromDb).toList();
    });
  }

  // save(user)
  Future<void> saveItem(model) async {
    await handleDatabaseOperation(() async {
      final db = await databaseService.database;
      await db.insert(
        tableName,
        toDb(model),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  // saveAll(items: [UserModel(...), UserModel(...)])
  Future<void> saveAllItems(items) async {
    await handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final batch = db.batch();
      for (var item in items) {
        batch.insert(
          tableName,
          toDb(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  // deleteById(idNumber: 1)
  Future<void> deleteItemById(dynamic id) async {
    await handleDatabaseOperation(() async {
      final db = await databaseService.database;
      await db.delete(tableName, where: '$keyField = ?', whereArgs: [id]);
    });
  }

  // search(query: 'john', fields: ['name', 'email'])
  Future<List<T>> search(String keyword, List<String> fields) async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final where = fields.map((f) => '$f LIKE ?').join(' OR ');
      final args = List.filled(fields.length, '%$keyword%');

      final results = await db.query(tableName, where: where, whereArgs: args);

      return results.map(fromDb).toList();
    });
  }

  Future<int> count() async {
    return handleDatabaseOperation(() async {
      final db = await databaseService.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableName',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    });
  }

  Future<void> syncItems() {
    AppError.create(
      message: 'Sync is not supported in local repository',
      type: ErrorType.database,
      shouldLog: true,
    );
    throw UnimplementedError('Sync is not supported in local repository');
  }
}
