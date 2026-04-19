import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.9),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(context, 'assets/images/logo.webp'),
                  const SizedBox(width: 10),
                  Text(
                    'GCare',
                    style: TextStyle(
                      color: colors.white,
                      fontWeight: weight.bold,
                      fontSize: 20,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              _buildLogo(context, 'assets/images/jrmsu_logo.webp'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, String assetPath) {
    final colors = context.colors;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.white,
        border: Border.all(color: colors.white, width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
