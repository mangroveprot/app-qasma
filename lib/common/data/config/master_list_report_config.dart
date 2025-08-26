class MasterlistConfig {
  static const String defaultTemplatePath =
      'assets/templates/masterlist_template.xlsx';
  static const String defaultOutputBaseName = 'masterlist_report';
  static const int headerRowIndex = 10;
  static const int dataStartRowIndex = 11;

  static const Map<String, int> columnIndices = {
    'No': 0,
    'Date': 1,
    'Name': 2,
    'Address': 3,
    'Contact No': 4,
    'Purpose': 5,
    'Status': 6,
  };

  static const Map<int, double> columnWidths = {
    0: 8.0, // No
    1: 15.0, // Date
    2: 25.0, // Name
    3: 30.0, // Address
    4: 18.0, // Contact No
    5: 20.0, // Purpose
    6: 18.0, // Date Scanned
  };
}
