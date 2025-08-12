import '../../domain/entities/cancellation.dart';

class CancellationModel extends Cancellation {
  const CancellationModel(
      {super.cancelledById, super.reason, super.cancelledAt});

  static String? _getValue(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    if (map.containsKey(key1)) {
      final value = map[key1];
      if (value != null) return value.toString();
    }

    if (key2 != null && map.containsKey(key2)) {
      final value = map[key2];
      if (value != null) return value.toString();
    }

    return null;
  }

  static DateTime? _getDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1]?.toString() ?? map[key2]?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    return null;
  }

  factory CancellationModel.fromMap(Map<String, dynamic> map) {
    return CancellationModel(
      cancelledById: _getValue(map, 'cancelledById', 'cancelled_by_id'),
      reason: _getValue(map, 'reason'),
      cancelledAt: _getDateTime(map, 'cancelledAt', 'cancelled_at'),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'cancelledById': cancelledById,
      'reason': reason,
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }

  Cancellation toEntity() {
    return Cancellation(
      cancelledById: cancelledById,
      reason: reason,
      cancelledAt: cancelledAt,
    );
  }

  factory CancellationModel.fromEntity(Cancellation entity) {
    return CancellationModel(
      cancelledById: entity.cancelledById,
      reason: entity.reason,
      cancelledAt: entity.cancelledAt,
    );
  }

  @override
  String toString() {
    return 'CancellationModel(cancelledById: $cancelledById, reason: $reason, cancelledAt: $cancelledAt)';
  }
}
