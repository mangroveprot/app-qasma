import 'package:flutter/material.dart';
import '../../infrastructure/theme/theme_extensions.dart';
import '../helpers/spacing.dart';

class CustomChevronButton extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData? icon;
  final double? iconSize;
  final double? fontSize;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final int? count;
  final Color? countBackgroundColor;
  final Color? countTextColor;

  const CustomChevronButton({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.icon,
    this.iconSize,
    this.fontSize,
    this.iconColor,
    this.iconBackgroundColor,
    this.padding,
    this.count,
    this.countBackgroundColor,
    this.countTextColor,
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
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconBackgroundColor ??
                                colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon,
                            color: iconColor ?? colors.primary,
                            size: iconSize ?? 18,
                          ),
                        ),
                        Spacing.horizontalMedium,
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: fontSize ?? 16,
                                fontWeight: fontWeight.medium,
                                color: colors.black,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontSize: fontSize != null
                                      ? (fontSize! / 1.5).toDouble()
                                      : (16 / 1.5).toDouble(),
                                  fontWeight: fontWeight.regular,
                                  color: colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (count != null) ...[
                        Spacing.horizontalSmall,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: countBackgroundColor ??
                                colors.textPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: fontWeight.medium,
                              color: countTextColor ?? colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.chevron_right,
                    color: iconColor ?? colors.textPrimary,
                    size: iconSize ?? 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
