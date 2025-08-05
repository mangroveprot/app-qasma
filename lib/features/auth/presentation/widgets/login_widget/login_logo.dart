import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98,
      height: 98,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.white,
        border: Border.all(color: context.colors.white, width: 3),
        boxShadow: [context.shadows.heavy],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.webp',
          fit: BoxFit.cover,
          cacheWidth: 98,
          cacheHeight: 98,
        ),
      ),
    );
  }
}
