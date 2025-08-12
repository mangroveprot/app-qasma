import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/theme_extensions.dart';
import '../models/modal_option.dart';

class EnhancedOptionCard extends StatefulWidget {
  const EnhancedOptionCard({
    super.key,
    required this.option,
    required this.onTap,
    this.iconData,
    this.isSelected = false,
  });

  final ModalOption option;
  final VoidCallback onTap;
  final IconData? iconData;
  final bool isSelected;

  @override
  State<EnhancedOptionCard> createState() => _EnhancedOptionCardState();
}

class _EnhancedOptionCardState extends State<EnhancedOptionCard> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radius = context.radii;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: widget.isSelected
            ? colors.textPrimary.withOpacity(0.1)
            : (isDark ? colors.surface : Colors.white),
        borderRadius: radius.large,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            widget.onTap();
          },
          borderRadius: radius.large,
          splashColor: colors.textPrimary.withOpacity(0.3),
          highlightColor: colors.textPrimary.withOpacity(0.15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: radius.large,
              border: Border.all(
                color: widget.isSelected
                    ? colors.primary
                    : (isDark
                        ? colors.textPrimary.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.15)),
                width: widget.isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? colors.primary.withOpacity(0.15)
                        : (isDark
                            ? colors.textPrimary.withOpacity(0.1)
                            : colors.textPrimary.withOpacity(0.05)),
                    borderRadius: radius.medium,
                  ),
                  child: Icon(
                    Icons.category_outlined,
                    color: widget.isSelected ? colors.primary : colors.black,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 16),

                // Content section
                Expanded(
                  child: Text(
                    widget.option.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: widget.isSelected
                          ? fontWeight.bold
                          : fontWeight.medium,
                      color: widget.isSelected ? colors.primary : colors.black,
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: widget.isSelected
                      ? colors.primary
                      : colors.textPrimary.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
