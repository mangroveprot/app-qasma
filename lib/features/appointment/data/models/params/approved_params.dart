class ApprovedParams {
  final String appointmentId;
  final String studentId;
  final String staffId;
  final String counselorId;
  final String status;

  ApprovedParams({
    required this.studentId,
    required this.staffId,
    required this.counselorId,
    required this.appointmentId,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'appointmentId': appointmentId,
        'studentId': studentId,
        'staffId': staffId,
        'counselorId': counselorId,
        'status': status,
      };
}
