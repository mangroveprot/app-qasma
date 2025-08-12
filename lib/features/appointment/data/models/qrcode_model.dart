import '../../domain/entities/qrcode.dart';

class QRCodeModel extends QRCode {
  const QRCodeModel({super.token, super.scannedById, super.scannedAt});

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

  factory QRCodeModel.fromMap(Map<String, dynamic> map) {
    return QRCodeModel(
      token: _getValue(map, 'token'),
      scannedById: _getValue(map, 'scannedById', 'scanned_by_id'),
      scannedAt: _getDateTime(map, 'scannedAt', 'scanned_at'),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'scannedById': scannedById,
      'scannedAt': scannedAt?.toIso8601String(),
    };
  }

  QRCode toEntity() {
    return QRCode(
      token: token,
      scannedById: scannedById,
      scannedAt: scannedAt,
    );
  }

  factory QRCodeModel.fromEntity(QRCode entity) {
    return QRCodeModel(
      token: entity.token,
      scannedById: entity.scannedById,
      scannedAt: entity.scannedAt,
    );
  }

  @override
  String toString() {
    return 'QRCodeModel(token: $token, scannedById: $scannedById, scannedAt: $scannedAt)';
  }
}
