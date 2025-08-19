class AvailabilityParams {
  final DateTime scheduledStartAt;
  final DateTime scheduledEndAt;

  AvailabilityParams(
      {required this.scheduledStartAt, required this.scheduledEndAt});

  Map<String, dynamic> toJson() => {
        'scheduledStartAt': scheduledStartAt.toIso8601String(),
        'scheduledEndAt': scheduledEndAt.toIso8601String(),
      };
}
