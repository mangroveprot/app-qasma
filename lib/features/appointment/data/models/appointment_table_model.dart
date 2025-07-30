import '../../../../core/_base/_models/table_model.dart';

class AppointmentTableModel implements TableModel {
  @override
  String get createTableQuery => '''
  CREATE TABLE appointments (
    appointmentId TEXT PRIMARY KEY,
    studentId TEXT NOT NULL,
    scheduledStartAt TEXT NOT NULL,    -- DateTime → ISO8601 String
    scheduledEndAt TEXT NOT NULL,      -- DateTime → ISO8601 String
    appointmentCategory TEXT NOT NULL,
    appointmentType TEXT NOT NULL,
    description TEXT NOT NULL,
    status TEXT NOT NULL,
    checkInStatus TEXT NOT NULL,
    qrCode TEXT NOT NULL,              -- QRCode → JSON stringified TEXT
    cancellation TEXT NOT NULL,        -- Cancellation → JSON stringified TEXT
    version INTEGER NOT NULL,          -- __version__ field

    -- Auditing fields
    createdAt TEXT NOT NULL,           -- DateTime → ISO8601 String
    updatedAt TEXT NOT NULL,
    createdBy TEXT NOT NULL,
    updatedBy TEXT,
    deletedAt TEXT,
    deletedBy TEXT,
    
    -- Foreign key constraint (optional)
    FOREIGN KEY (studentId) REFERENCES users(idNumber)
  )
''';

  @override
  List<String> get createIndexes => [
        'CREATE INDEX idx_appointments_student_id ON appointments(studentId)',
        'CREATE INDEX idx_appointments_status ON appointments(status)',
        'CREATE INDEX idx_appointments_scheduled_start ON appointments(scheduledStartAt)',
        'CREATE INDEX idx_appointments_appointment_type ON appointments(appointmentType)',
        'CREATE INDEX idx_appointments_appointment_category ON appointments(appointmentCategory)',
        'CREATE INDEX idx_appointments_check_in_status ON appointments(checkInStatus)',
      ];
}

/*
NOTE: If you want to search nested JSON fields, use json_extract:

-- Search by QR code token
SELECT * FROM appointments WHERE json_extract(qrCode, '$.token') = 'some-token';

-- Search by cancellation reason
SELECT * FROM appointments WHERE json_extract(cancellation, '$.reason') = 'Emergency';

-- Check if appointment is cancelled
SELECT * FROM appointments WHERE json_extract(cancellation, '$.cancelledAt') IS NOT NULL;

-- Check if QR code is scanned
SELECT * FROM appointments WHERE json_extract(qrCode, '$.scannedAt') IS NOT NULL;

-- Find appointments by scanned user
SELECT * FROM appointments WHERE json_extract(qrCode, '$.scannedById') = 'user-id';
*/