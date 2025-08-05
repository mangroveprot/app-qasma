import '../../../../core/_base/_models/table_model.dart';

class AppointmentConfigTableModel implements TableModel {
  @override
  String get createTableQuery => '''
  CREATE TABLE appointment_configs (
    configId TEXT PRIMARY KEY,
    sessionDuration INTEGER,
    bufferTime INTEGER,
    bookingLeadTime INTEGER,
    slotDaysRange INTEGER,
    reminders TEXT,                     -- List<Reminder> → JSON stringified TEXT
    availableDayTime TEXT,              -- REMOVED NOT NULL - now nullable
    categoryAndType TEXT,               -- REMOVED NOT NULL - now nullable

    -- Auditing fields  
    createdAt TEXT,                     -- REMOVED NOT NULL - now nullable
    updatedAt TEXT,                     -- REMOVED NOT NULL - now nullable
    createdBy TEXT,                     -- REMOVED NOT NULL - now nullable
    updatedBy TEXT,
    deletedAt TEXT,                     -- DateTime → ISO8601 String
    deletedBy TEXT
  )
''';

  @override
  List<String> get createIndexes => [
        'CREATE INDEX idx_appointment_configs_session_duration ON appointment_configs(sessionDuration)',
        'CREATE INDEX idx_appointment_configs_buffer_time ON appointment_configs(bufferTime)',
        'CREATE INDEX idx_appointment_configs_booking_lead_time ON appointment_configs(bookingLeadTime)',
        'CREATE INDEX idx_appointment_configs_slot_days_range ON appointment_configs(slotDaysRange)',
        'CREATE INDEX idx_appointment_configs_created_at ON appointment_configs(createdAt)',
        'CREATE INDEX idx_appointment_configs_updated_at ON appointment_configs(updatedAt)',
      ];
}
