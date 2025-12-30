import 'package:flutter/material.dart';

import '../../../../theme/theme_extensions.dart';
import '../../models/modal_option.dart';

class EnhancedRadioCard extends StatefulWidget {
  const EnhancedRadioCard({
    super.key,
    required this.option,
    required this.onTap,
    required this.isSelected,
  });

  final ModalOption option;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  State<EnhancedRadioCard> createState() => _EnhancedRadioCardState();
}

class _EnhancedRadioCardState extends State<EnhancedRadioCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(EnhancedRadioCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      // No need for complex animations on selection change
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              // margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? colors.primary.withOpacity(0.08)
                    : Colors.white,
                borderRadius: radius.medium,
                border: Border.all(
                  color: widget.isSelected
                      ? colors.primary
                      : Colors.grey.withOpacity(0.25),
                  width: widget.isSelected ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon (if available)
                  if (widget.option.icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(2),
                      child: widget.option.icon,
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title

                        if (widget.option.title.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.option.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: widget.isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: widget.isSelected
                                  ? colors.primary
                                  : Colors.grey[800],
                            ),
                          ),
                        ],

                        // Subtitle (if available)
                        if (widget.option.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.option.subtitle!,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Radio button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isSelected
                            ? colors.primary
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: widget.isSelected
                          ? colors.primary
                          : Colors.transparent,
                    ),
                    child: widget.isSelected
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
