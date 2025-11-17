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

class _EnhancedOptionCardState extends State<EnhancedOptionCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasDescription =
        widget.option.subtitle != null && widget.option.subtitle!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _scaleController
                  .forward()
                  .then((_) => _scaleController.reverse());
              widget.onTap();
            },
            onTapDown: (_) => _scaleController.forward(),
            onTapUp: (_) => _scaleController.reverse(),
            onTapCancel: () => _scaleController.reverse(),
            onHover: (hover) => setState(() => _isHovered = hover),
            borderRadius: BorderRadius.circular(12),
            splashColor: colors.primary.withOpacity(0.05),
            highlightColor: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? colors.primary.withOpacity(isDark ? 0.15 : 0.08)
                    : (isDark ? colors.surface.withOpacity(0.6) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isSelected
                      ? colors.primary.withOpacity(isDark ? 0.4 : 0.3)
                      : (isDark
                          ? colors.textPrimary.withOpacity(0.08)
                          : const Color(0xFFE5E7EB)),
                  width: widget.isSelected ? 1.5 : 1,
                ),
                boxShadow: [
                  if (!isDark && (_isHovered || widget.isSelected))
                    BoxShadow(
                      color: widget.isSelected
                          ? colors.primary.withOpacity(0.1)
                          : Colors.black.withOpacity(0.04),
                      blurRadius: widget.isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    if (widget.iconData != null) ...[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.isSelected
                              ? colors.primary.withOpacity(isDark ? 0.2 : 0.12)
                              : (isDark
                                  ? colors.textPrimary.withOpacity(0.06)
                                  : const Color(0xFFF9FAFB)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.iconData,
                          color: widget.isSelected
                              ? colors.primary
                              : colors.textPrimary
                                  .withOpacity(isDark ? 0.7 : 0.5),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Title and Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.option.title,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: widget.isSelected
                                  ? fontWeight.medium
                                  : fontWeight.medium,
                              fontSize: 15,
                              color: widget.isSelected
                                  ? colors.primary
                                  : (isDark
                                      ? colors.textPrimary.withOpacity(0.95)
                                      : const Color(0xFF111827)),
                              letterSpacing: -0.2,
                              height: 1.4,
                            ),
                          ),
                          if (hasDescription) ...[
                            const SizedBox(height: 3),
                            Text(
                              widget.option.subtitle!,
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: fontWeight.regular,
                                fontSize: 13,
                                color: isDark
                                    ? colors.textPrimary.withOpacity(0.55)
                                    : const Color(0xFF6B7280),
                                letterSpacing: -0.1,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Chevron icon with subtle animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.translationValues(
                        _isHovered ? 2 : 0,
                        0,
                        0,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: widget.isSelected
                            ? colors.primary.withOpacity(0.8)
                            : colors.textPrimary
                                .withOpacity(isDark ? 0.3 : 0.4),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
