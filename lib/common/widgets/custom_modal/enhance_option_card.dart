import 'package:flutter/material.dart';

import '../../../theme/theme_extensions.dart';
import '../models/modal_option.dart';

class EnhancedOptionCard extends StatefulWidget {
  const EnhancedOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  final ModalOption option;
  final VoidCallback onTap;

  @override
  State<EnhancedOptionCard> createState() => _EnhancedOptionCardState();
}

class _EnhancedOptionCardState extends State<EnhancedOptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _checkAnimation;
  late final Animation<Color?> _colorAnimation;
  late final Animation<Color?> _textColorAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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
      begin: Colors.grey[100],
      end: colors.textPrimary.withOpacity(0.1),
    ).animate(_controller);

    _textColorAnimation = ColorTween(
      begin: Colors.black,
      end: colors.textPrimary,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    if (!_isPressed) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radius = context.radii;

    return InkWell(
      onTap: widget.onTap,
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: _handleTapUp,
      borderRadius: radius.medium,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: radius.medium,
              border: _isPressed
                  ? Border.all(
                      color: colors.textPrimary.withOpacity(0.1),
                      width: 2,
                    )
                  : null,
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: colors.textPrimary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                if (widget.option.icon != null)
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: widget.option.icon,
                  ),
                if (widget.option.icon != null) const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: fontWeight.bold,
                          color: _textColorAnimation.value,
                        ),
                        child: Text(widget.option.title),
                      ),
                      if (widget.option.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.option.subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Transform.scale(
                  scale: _checkAnimation.value,
                  child: Opacity(
                    opacity: _checkAnimation.value,
                    child: Icon(Icons.check_circle, color: colors.primary),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
