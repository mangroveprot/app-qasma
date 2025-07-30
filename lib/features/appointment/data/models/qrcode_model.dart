import '../../domain/entities/qrcode.dart';

class QRCodeModel extends QRCode {
  const QRCodeModel({super.token, super.scannedById, super.scannedAt});

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
  factory QRCodeModel.fromMap(Map<String, dynamic> map) {
    return QRCodeModel(
      token: _getValue(map, 'token'),
      scannedById: _getValue(map, 'scannedById'),
      scannedAt: _getDateTime(map, 'scannedAt'),
    );
  }

  // for sqlite
  @override
  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'scannedById': scannedById,
      'scannedAt': scannedAt?.toIso8601String(),
    };
  }

  // convert to entity
  QRCode toEntity() {
    return QRCode(
      token: token,
      scannedById: scannedById,
      scannedAt: scannedAt,
    );
  }

  // convert from entity
  factory QRCodeModel.fromEntity(QRCode entity) {
    return QRCodeModel(
      token: entity.token,
      scannedById: entity.scannedById,
      scannedAt: entity.scannedAt,
    );
  }
}
