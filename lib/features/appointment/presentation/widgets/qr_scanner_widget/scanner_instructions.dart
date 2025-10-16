import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class ScannerInstructions extends StatelessWidget {
  final String? customMessage;

  const ScannerInstructions({
    super.key,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          customMessage ?? 'Scan the QR code to verify your session.',
          style: TextStyle(
            color: colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
