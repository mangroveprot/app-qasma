import '../../../../core/_base/_models/table_model.dart';

class UserTableModel implements TableModel {
  @override
  String get createTableQuery => '''
  CREATE TABLE users (
    idNumber TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    role TEXT NOT NULL,
    verified INTEGER NOT NULL,         -- bool → INTEGER (0 or 1)
    active INTEGER NOT NULL,           -- bool → INTEGER (0 or 1)
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT NOT NULL,
    suffix TEXT NOT NULL,
    gender TEXT NOT NULL,
    date_of_birth TEXT NOT NULL,       -- DateTime → ISO8601 String
    address TEXT NOT NULL,
    contact_number TEXT NOT NULL,
    facebook TEXT NOT NULL,
    other_info TEXT NOT NULL,          -- OtherInfo → JSON stringified TEXT

    -- Auditing fields
    createdAt TEXT NOT NULL,           -- DateTime → ISO8601 String
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
