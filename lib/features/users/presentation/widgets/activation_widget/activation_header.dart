import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../theme/theme_extensions.dart';

class ActivationHeader extends StatelessWidget {
  const ActivationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        _buildLockIcon(colors),
        const SizedBox(height: 10),
        const Text(
          'Account Registration Required',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Present this QR code to guidance office staff to activate your appointment access',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLockIcon(AppColors color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_outline,
        color: color.primary,
        size: 24,
      ),
    );
  }
}
