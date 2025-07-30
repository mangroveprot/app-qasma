import '../../domain/entities/cancellation.dart';

class CancellationModel extends Cancellation {
  const CancellationModel(
      {super.cancelledById, super.reason, super.cancelledAt});

  // helper value safety
  static String? _getValue(Map<String, dynamic> map, String key) {
    final value = map[key];
    return value != null ? value.toString() : null;
  }

  static DateTime? _getDateTime(Map<String, dynamic> map, String key) {
    final value = map[key];
    return value != null ? DateTime.parse(value.toString()) : null;
  }

  // convert from for API
  factory CancellationModel.fromMap(Map<String, dynamic> map) {
    return CancellationModel(
      cancelledById: _getValue(map, 'cancelledById'),
      reason: _getValue(map, 'reason'),
      cancelledAt: _getDateTime(map, 'cancelledAt'),
    );
  }

  // for sqlite
  @override
  Map<String, dynamic> toMap() {
    return {
      'cancelledById': cancelledById,
      'reason': reason,
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }

  // convert to entity
  Cancellation toEntity() {
    return Cancellation(
      cancelledById: cancelledById,
      reason: reason,
      cancelledAt: cancelledAt,
    );
  }

  // convert from entity
  factory CancellationModel.fromEntity(Cancellation entity) {
    return CancellationModel(
      cancelledById: entity.cancelledById,
      reason: entity.reason,
      cancelledAt: entity.cancelledAt,
    );
  }
}
