import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? borderWidth;
  final double? spacing;
  final Map<String, String>? customStatusTexts;
  final Map<String, IconData>? customIcons;
  final double? backgroundOpacity;
  final double? borderOpacity;

  const StatusChip({
    super.key,
    required this.status,
    this.fontSize = 12,
    this.fontWeight,
    this.letterSpacing = 0.3,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius = 20,
    this.borderWidth = 1,
    this.spacing = 4,
    this.customStatusTexts,
    this.customIcons,
    this.backgroundOpacity = 0.1,
    this.borderOpacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    final statusLower = status.toLowerCase();
    final isApproved = statusLower == 'approved';
    final isPending = statusLower == 'pending';
    final isCompleted = statusLower == 'completed';

    Color textColor;
    Color backgroundColor;

    if (isApproved) {
      textColor = colors.primary;
      backgroundColor = colors.primary.withOpacity(backgroundOpacity!);
    } else if (isPending) {
      textColor = colors.warning;
      backgroundColor = colors.warning.withOpacity(backgroundOpacity!);
    } else if (isCompleted) {
      textColor = colors.primary;
      backgroundColor = colors.primary.withOpacity(backgroundOpacity!);
    } else {
      textColor = colors.error;
      backgroundColor = colors.error.withOpacity(backgroundOpacity!);
    }

    String statusText;
    if (customStatusTexts?.containsKey(statusLower) == true) {
      statusText = customStatusTexts![statusLower]!;
    } else {
      if (isApproved) {
        statusText = 'Approved';
      } else if (isPending) {
        statusText = 'Pending';
      } else if (isCompleted) {
        statusText = 'Completed';
      } else {
        statusText = 'Cancelled';
      }
    }

    IconData icon;
    if (customIcons?.containsKey(statusLower) == true) {
      icon = customIcons![statusLower]!;
    } else {
      if (isApproved) {
        icon = Icons.check_circle_rounded;
      } else if (isPending) {
        icon = Icons.schedule_rounded;
      } else if (isCompleted) {
        icon = Icons.check_circle_outline_rounded;
      } else {
        icon = Icons.cancel_rounded;
      }
    }

    return Container(
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
            icon,
            size: fontSize,
            color: textColor,
          ),
          SizedBox(width: spacing),
          Text(
            statusText,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight ?? weight.medium,
              color: textColor,
              letterSpacing: letterSpacing,
            ),
          ),
        ],
      ),
    );
  }
}
