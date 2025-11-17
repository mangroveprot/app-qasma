import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../../../appointment/domain/entities/qrcode.dart';
import '../../../../appointment/presentation/pages/qrcode_page.dart';

class CardQRCodeSection extends StatelessWidget {
  final QRCode qrData;
  final VoidCallback? onTap;
  final VoidCallback? onBackPressed;

  const CardQRCodeSection({
    super.key,
    required this.qrData,
    this.onTap,
    this.onBackPressed,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
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
                errorStateBuilder: (cxt, err) {
                  return const Center(
                    child: Text(
                      'QR Error',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 8),
                    ),
                  );
                },
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(4),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap for full view',
            style: TextStyle(
              fontSize: 10,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToQRCodePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QrCodePage(
          qrData: qrData,
          onBackPressed: onBackPressed,
        ),
      ),
    );
  }
}
