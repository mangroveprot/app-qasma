// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';

class OtpIconSection extends StatelessWidget {
  const OtpIconSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorsBlack = Colors.black87;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: context.colors.white.withOpacity(0.8),
            child: Icon(Icons.mail_outline, size: 40, color: colorsBlack),
          ),
          Spacing.verticalMedium,
          Text(
            'OTP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: context.weight.bold,
              color: colorsBlack,
            ),
          ),
        ],
      ),
    );
  }
}
