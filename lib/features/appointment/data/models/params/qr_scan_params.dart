class QRScanParams {
  final String? token;
  final String appointmentId;
  final String studentId;
  final String counselorId;

  QRScanParams({
    this.token,
    required this.studentId,
    required this.counselorId,
    required this.appointmentId,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'appointmentId': appointmentId,
        'studentId': studentId,
        'counselorId': counselorId,
      };
}
