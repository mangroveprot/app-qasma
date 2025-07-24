import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // University Name
        Text(
          'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: context.weight.medium,
            color: context.colors.primary,
            letterSpacing: 0.5,
            shadows: [
              const Shadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 8,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        Spacing.verticalXSmall,
        // app name
        Text(
          'QR CODE-ENABLED\nAPPOINTMENT AND\nSCHEDULING MANAGER\nAPPLICATION',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: context.weight.bold,
            color: context.colors.textPrimary,
            height: 1.3,
            shadows: [
              const Shadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        Spacing.verticalXSmall,
        // university branch
        const Text(
          'KATIPUNAN CAMPUS, Z.N',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFA726),
            letterSpacing: 1.0,
            shadows: [
              Shadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        Spacing.verticalXSmall,
        Text(
          'STUDENT',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: context.weight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
