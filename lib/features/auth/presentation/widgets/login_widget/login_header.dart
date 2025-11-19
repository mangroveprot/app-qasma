import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Semantics(
          header: true,
          child: const Text(
            'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C2C54),
              letterSpacing: 0.5,
              height: 1.3,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2.0,
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: Text(
            'Guidance Care',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
              height: 1.2,
              letterSpacing: 0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Campus location: Katipunan Campus, Z.N',
          child: const Text(
            'KATIPUNAN CAMPUS, Z.N',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFFD84315),
              letterSpacing: 1.0,
              height: 1.3,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2.0,
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                ),
              ],
            ),
          ),
        ),
        Spacing.verticalXSmall,
        Text(
          'COUNSELOR',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: context.weight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
