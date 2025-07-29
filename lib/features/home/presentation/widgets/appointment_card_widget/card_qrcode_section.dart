import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class CardQRCodeSection extends StatelessWidget {
  const CardQRCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.accent,
          width: 2,
        ),
        borderRadius: radius.small,
      ),
      child: Icon(
        Icons.qr_code,
        size: 35,
        color: colors.accent,
      ),
    );
  }
}
