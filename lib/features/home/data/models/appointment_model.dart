class AppointmentData {
  final String id;
  final String date;
  final String time;
  final String type;
  final String appointmentType;
  final AppointmentStatus status;
  final String qrCode;
  final String description;

  const AppointmentData(
      {required this.id,
      required this.date,
      required this.time,
      required this.type,
      required this.appointmentType,
      required this.status,
      required this.qrCode,
      required this.description});
}

enum AppointmentStatus { approved, pending, cancelled }
