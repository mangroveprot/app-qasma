import '../cancellation_model.dart';

class CancelParams {
  final String appointmentId;
  final CancellationModel cancellation;

  CancelParams({required this.appointmentId, required this.cancellation});

  Map<String, dynamic> toJson() => {
        'appointmentId': appointmentId,
        'cancellation': cancellation.toMap(),
      };
}
