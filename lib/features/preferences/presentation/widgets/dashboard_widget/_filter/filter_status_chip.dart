import 'package:flutter/material.dart';

import '../../../../../../infrastructure/theme/theme_extensions.dart';

class FilterStatusChip extends StatelessWidget {
  final String value;
  final String label;
  final bool isSelected;
  final Color? dotColor;
  final VoidCallback onTap;

  const FilterStatusChip({
    Key? key,
    required this.value,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.dotColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final resolvedDotColor = dotColor ?? colors.textPrimary.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withOpacity(0.08)
              : colors.surface.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? colors.primary.withOpacity(0.6) : colors.surface,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: resolvedDotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? colors.primary : colors.black,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 5),
              Icon(Icons.check_rounded, size: 13, color: colors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
