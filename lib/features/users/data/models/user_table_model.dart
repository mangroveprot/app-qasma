import '../../../../core/_base/_models/table_model.dart';

class UserTableModel implements TableModel {
  @override
  String get createTableQuery => '''
    CREATE TABLE users (
      idNumber TEXT PRIMARY KEY,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      role TEXT NOT NULL,
      verified INTEGER NOT NULL,
      active INTEGER NOT NULL,
      first_name TEXT NOT NULL,
      last_name TEXT NOT NULL,
      middle_name TEXT,
      suffix TEXT,
      gender TEXT NOT NULL,
      date_of_birth INTEGER NOT NULL,
      address TEXT,
      contact_number TEXT,
      facebook TEXT,
      other_info TEXT,

      -- Auditing fields
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
    'CREATE UNIQUE INDEX idx_users_email ON users(email)',
  ];
}

/*
NOTE: If u want to search the field by otherinfo do it like this.
SELECT * FROM users WHERE json_extract(other_info, '$.course') = 'BSIT';
*/
