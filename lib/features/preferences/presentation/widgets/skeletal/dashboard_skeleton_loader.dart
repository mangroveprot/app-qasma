import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class DashboardSkeletonLoader {
  static Widget dashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards grid
          Row(
            children: [
              Expanded(
                child: _statsCardSkeleton(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statsCardSkeleton(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statsCardSkeleton(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statsCardSkeleton(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Appointments Status section
          _appointmentsStatusSkeleton(),
        ],
      ),
    );
  }

  static Widget _statsCardSkeleton() {
    return _SkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SkeletonBox(width: 20, height: 20, borderRadius: 6),
          const SizedBox(height: 8),
          const _SkeletonBox(width: 70, height: 14, borderRadius: 4),
          const SizedBox(height: 6),
          const _SkeletonBox(width: 30, height: 24, borderRadius: 4),
        ],
      ),
    );
  }

  static Widget _appointmentsStatusSkeleton() {
    return _SkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SkeletonBox(width: 140, height: 20, borderRadius: 4),
          const SizedBox(height: 16),

          // Circular chart placeholder
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE8E8E8),
                  width: 10,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _SkeletonBox(width: 24, height: 16, borderRadius: 4),
                    const SizedBox(height: 2),
                    const _SkeletonBox(width: 50, height: 12, borderRadius: 4),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Status list
          _statusRowSkeleton(),
          const SizedBox(height: 12),
          _statusRowSkeleton(),
          const SizedBox(height: 12),
          _statusRowSkeleton(),
        ],
      ),
    );
  }

  static Widget _statusRowSkeleton() {
    return Row(
      children: [
        const _SkeletonBox(width: 24, height: 24, borderRadius: 12),
        const SizedBox(width: 10),
        const _SkeletonBox(width: 60, height: 14, borderRadius: 4),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SkeletonBox(width: 16, height: 16, borderRadius: 4),
            const SizedBox(height: 2),
            const _SkeletonBox(width: 24, height: 12, borderRadius: 4),
          ],
        ),
      ],
    );
  }
}

/// Card wrapper for skeleton content
class _SkeletonCard extends StatelessWidget {
  final Widget child;

  const _SkeletonCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Basic skeleton box with shimmer effect
class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const _SkeletonBox({
    this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment(-1.0, 0.0),
          end: Alignment(1.0, 0.0),
          colors: [
            Color(0xFFE8E8E8),
            Color(0xFFF5F5F5),
            Color(0xFFE8E8E8),
          ],
        ),
      ),
      child: _ShimmerAnimation(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

/// Shimmer animation widget
class _ShimmerAnimation extends StatefulWidget {
  final Widget child;

  const _ShimmerAnimation({required this.child});

  @override
  State<_ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<_ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.transparent,
                Colors.white54,
                Colors.transparent,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
