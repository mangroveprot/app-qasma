import 'package:flutter/material.dart';

import '../../../../../common/helpers/maskEmail.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class OtpHederSection extends StatelessWidget {
  final email;
  const OtpHederSection({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Account Verification',
            style: TextStyle(fontSize: 14, fontWeight: context.weight.bold),
          ),
          Spacing.verticalMedium,
          Text(
            'Please enter the 6-digit code sent to your email ${maskEmail(email)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
