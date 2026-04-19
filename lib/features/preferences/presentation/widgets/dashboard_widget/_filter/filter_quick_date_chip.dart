import 'package:flutter/material.dart';

import '../../../../../../infrastructure/theme/theme_extensions.dart';

class FilterQuickDateChip extends StatelessWidget {
  final String type;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FilterQuickDateChip({
    Key? key,
    required this.type,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? colors.primary : colors.surface.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? colors.primary : colors.surface,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? colors.white : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
