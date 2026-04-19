import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../theme/theme_extensions.dart';

class ActivationQRSection extends StatelessWidget {
  final String studentId;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  const ActivationQRSection({
    super.key,
    required this.studentId,
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Activation QR Code',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 6),
          _buildQRCodeContainer(colors),
          const SizedBox(height: 6),
          Text(
            studentId,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.secondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          _buildRefreshButton(colors, screenWidth),
        ],
      ),
    );
  }

  Widget _buildQRCodeContainer(AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: QrImage(
        data: studentId,
        version: QrVersions.auto,
        size: 110.0,
        backgroundColor: colors.white,
        foregroundColor: colors.black,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
      ),
    );
  }

  Widget _buildRefreshButton(AppColors colors, double screenWidth) {
    final isLarge = screenWidth >= 600;
    final isMedium = screenWidth >= 400;

    final iconSize = isLarge
        ? 18.0
        : isMedium
            ? 14.0
            : 12.0;
    final fontSize = isLarge
        ? 13.0
        : isMedium
            ? 11.0
            : 9.0;
    final verticalPadding = isLarge
        ? 10.0
        : isMedium
            ? 8.0
            : 6.0;
    final horizontalPadding = isLarge
        ? 16.0
        : isMedium
            ? 12.0
            : 10.0;
    final spinnerSize = isLarge
        ? 18.0
        : isMedium
            ? 14.0
            : 12.0;
    final spacing = isLarge
        ? 8.0
        : isMedium
            ? 6.0
            : 5.0;

    return GestureDetector(
      onTap: onRefresh,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isRefreshing
                ? SizedBox(
                    width: spinnerSize,
                    height: spinnerSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.secondary.withOpacity(0.8),
                      ),
                    ),
                  )
                : Icon(Icons.refresh, size: iconSize, color: colors.secondary),
            SizedBox(width: spacing),
            Text(
              'Already verified? Tap to refresh',
              style: TextStyle(
                fontSize: fontSize,
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
