import '../../../../core/_base/_models/table_model.dart';

class NotificationTableModel extends TableModel {
  @override
  String get createTableQuery => '''
    CREATE TABLE notifications (
      notificationId TEXT PRIMARY KEY,
      userId TEXT NOT NULL,
      type TEXT NOT NULL,
      title TEXT NOT NULL,
      body TEXT NOT NULL,
      data TEXT NOT NULL,
      status TEXT NOT NULL,
      sentAt TEXT,
      readAt TEXT,
      fcmResponse TEXT,
      createdAt TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
  ''';

  @override
  List<String> get createIndexes => [
        'CREATE INDEX idx_notifications_userId ON notifications(userId)',
        'CREATE INDEX idx_notifications_status ON notifications(status)',
        'CREATE INDEX idx_notifications_createdAt ON notifications(createdAt DESC)',
      ];
}
