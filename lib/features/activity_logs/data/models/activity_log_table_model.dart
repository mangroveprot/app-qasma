import '../../../../core/_base/_models/table_model.dart';

class ActivityLogTableModel extends TableModel {
  @override
  String get createTableQuery => '''
    CREATE TABLE activity_logs (
      activityId TEXT PRIMARY KEY,
      userId TEXT,
      category TEXT NOT NULL,
      action TEXT NOT NULL,
      relatedId TEXT,
      details TEXT NOT NULL,
      ipAddress TEXT,
      device TEXT,
      userAgent TEXT,
      platform TEXT,
      appVersion TEXT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL,
      createdBy TEXT,
      updatedBy TEXT,
      deletedAt TEXT,
      deletedBy TEXT
    )
  ''';

  @override
  List<String> get createIndexes => [
        'CREATE INDEX idx_activity_logs_userId ON activity_logs(userId)',
        'CREATE INDEX idx_activity_logs_category ON activity_logs(category)',
        'CREATE INDEX idx_activity_logs_createdAt ON activity_logs(createdAt DESC)',
        'CREATE INDEX idx_activity_logs_userId_createdAt ON activity_logs(userId, createdAt DESC)',
      ];
}
