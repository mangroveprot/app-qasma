import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';
import '../helpers/spacing.dart';

class CustomChevronButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final double? iconSize;
  final double? fontSize;
  final Color? iconColor;

  const CustomChevronButton({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.iconSize,
    this.fontSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final shadows = context.shadows;
    final fontWeight = context.weight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.white.withOpacity(0.8),
        borderRadius: radius.medium,
        boxShadow: [shadows.light],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius.medium,
        child: InkWell(
          borderRadius: radius.medium,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: iconColor ?? colors.textPrimary,
                        size: iconSize ?? 24,
                      ),
                      Spacing.horizontalMedium,
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize ?? 16,
                        fontWeight: fontWeight.medium,
                        color: colors.black,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: iconColor ?? colors.textPrimary,
                  size: iconSize ?? 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
