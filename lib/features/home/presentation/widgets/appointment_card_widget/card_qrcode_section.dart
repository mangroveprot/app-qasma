import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/domain/entities/qrcode.dart';
import '../../../../auth/presentation/pages/qrcode_page.dart';

class CardQRCodeSection extends StatelessWidget {
  final QRCode qrData;
  final VoidCallback? onTap;

  const CardQRCodeSection({
    super.key,
    required this.qrData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (qrData.token == null) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final radius = context.radii;

    return GestureDetector(
      onTap: onTap ?? () => _navigateToQRCodePage(context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: colors.accent,
            width: 1,
          ),
          borderRadius: radius.small,
        ),
        child: ClipRRect(
          borderRadius: radius.small,
          child: QrImage(
            data: qrData.token.toString(),
            version: QrVersions.auto,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            errorCorrectionLevel: QrErrorCorrectLevel.M,
            padding: const EdgeInsets.all(4),
          ),
        ),
      ),
    );
  }

  void _navigateToQRCodePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QrCodePage(
          qrData: qrData,
        ),
      ),
    );
  }
}
