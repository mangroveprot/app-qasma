import 'package:equatable/equatable.dart';

class Cancellation extends Equatable {
  final String? cancelledById;
  final String? reason;
  final DateTime? cancelledAt;

  const Cancellation({this.cancelledById, this.reason, this.cancelledAt});

  factory Cancellation.fromMap(Map<String, dynamic> map) {
    return Cancellation(
      cancelledById: map['cancelledById'],
      reason: map['reason'],
      cancelledAt: map['cancelledAt'] != null
          ? DateTime.parse(map['cancelledAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cancelledById': cancelledById,
      'reason': reason,
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [cancelledById, reason, cancelledAt];
}
