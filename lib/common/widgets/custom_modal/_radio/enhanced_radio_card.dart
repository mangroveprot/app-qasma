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
  late final Animation<Color?> _colorAnimation;
  late final Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final colors = context.colors;

    _colorAnimation = ColorTween(
      begin:
          widget.isSelected ? colors.primary.withOpacity(0.1) : Colors.grey[50],
      end: widget.isSelected
          ? colors.primary.withOpacity(0.15)
          : Colors.grey[100],
    ).animate(_controller);

    _textColorAnimation = ColorTween(
      begin: widget.isSelected ? colors.primary : colors.textPrimary,
      end: widget.isSelected ? colors.primary : colors.textPrimary,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(EnhancedRadioCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radius = context.radii;

    return InkWell(
      onTap: widget.onTap,
      borderRadius: radius.medium,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? colors.primary.withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: radius.medium,
                border: Border.all(
                  color: widget.isSelected
                      ? colors.primary
                      : Colors.grey.withOpacity(0.3),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: colors.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.option.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.option.subtitle!,
                            style: TextStyle(fontSize: 14, color: colors.black),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Radio button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isSelected ? colors.primary : Colors.grey,
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
