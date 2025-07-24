import 'package:flutter/material.dart';
import '../../../theme/theme_extensions.dart';
import '../../helpers/spacing.dart';
import 'toast_enums.dart';
import 'toast_item.dart';

class AnimatedToast extends StatefulWidget {
  final ToastItem toast;
  final VoidCallback onDismiss;

  const AnimatedToast({
    super.key,
    required this.toast,
    required this.onDismiss,
  });

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _getConstrainedContainer(Widget child) {
    switch (widget.toast.position) {
      case ToastPosition.topCenter:
      case ToastPosition.bottomCenter:
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        );
      case ToastPosition.center:
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 32,
          ),
          child: child,
        );
      default: // topRight, bottomRight
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder:
          (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: _getConstrainedContainer(
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: widget.toast.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [context.shadows.light],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.toast.icon != null) ...[
                          Icon(
                            widget.toast.icon,
                            color: widget.toast.textColor,
                            size: 18,
                          ),
                          Spacing.horizontalXSmall,
                        ],
                        Expanded(
                          child: Text(
                            widget.toast.message,
                            style: TextStyle(
                              color: widget.toast.textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.toast.actionLabel != null) ...[
                              Spacing.horizontalXSmall,
                              TextButton(
                                onPressed: () {
                                  widget.toast.onAction?.call();
                                  widget.onDismiss();
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  widget.toast.actionLabel!,
                                  style: TextStyle(
                                    color: context.colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            if (widget.toast.showCloseButton) ...[
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: widget.onDismiss,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    // ignore: deprecated_member_use
                                    color: widget.toast.textColor.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
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
