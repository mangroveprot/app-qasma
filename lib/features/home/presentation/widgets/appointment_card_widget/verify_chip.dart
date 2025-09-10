import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class VerifyChip extends StatelessWidget {
  final VoidCallback onPressed;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? borderWidth;
  final double? spacing;
  final double? backgroundOpacity;
  final double? borderOpacity;

  const VerifyChip({
    super.key,
    required this.onPressed,
    this.fontSize = 12,
    this.fontWeight,
    this.letterSpacing = 0.3,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius = 20,
    this.borderWidth = 1,
    this.spacing = 4,
    this.backgroundOpacity = 0.1,
    this.borderOpacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    final textColor = colors.primary;
    final backgroundColor = colors.primary.withOpacity(backgroundOpacity!);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius!),
          border: Border.all(
            color: textColor.withOpacity(borderOpacity!),
            width: borderWidth!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified_rounded,
              size: fontSize,
              color: textColor,
            ),
            SizedBox(width: spacing),
            Text(
              'Verify',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight ?? weight.medium,
                color: textColor,
                letterSpacing: letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
