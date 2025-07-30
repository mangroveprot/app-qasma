import 'package:equatable/equatable.dart';

class QRCode extends Equatable {
  final String? token;
  final String? scannedById;
  final DateTime? scannedAt;

  const QRCode({this.token, this.scannedById, this.scannedAt});

  factory QRCode.fromMap(Map<String, dynamic> map) {
    return QRCode(
      token: map['token'],
      scannedById: map['scannedById'],
      scannedAt:
          map['scannedAt'] != null ? DateTime.parse(map['scannedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'scannedById': scannedById,
      'scannedAt': scannedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [token, scannedById, scannedAt];
}
