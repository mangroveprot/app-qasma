import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.white,
            border: Border.all(color: context.colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/jrmsu_logo.webp',
              fit: BoxFit.cover,
              cacheWidth: 65,
              cacheHeight: 65,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.white,
            border: Border.all(color: context.colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.webp',
              fit: BoxFit.cover,
              cacheWidth: 65,
              cacheHeight: 65,
            ),
          ),
        ),
      ],
    );
  }
}
