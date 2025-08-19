import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class MyProfileSkeletonLoader {
  static Widget profilePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          _SkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _SkeletonBox(width: 24, height: 24, borderRadius: 12),
                    const SizedBox(width: 12),
                    const _SkeletonBox(width: 100, height: 20, borderRadius: 4),
                  ],
                ),
                const SizedBox(height: 8),
                const _SkeletonBox(width: 200, height: 14, borderRadius: 4),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Personal Information section
          Row(
            children: [
              const _SkeletonBox(width: 20, height: 20, borderRadius: 4),
              const SizedBox(width: 8),
              const _SkeletonBox(width: 150, height: 20, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 16),

          // Form fields
          Expanded(
            child: ListView.separated(
              itemCount:
                  5, // First Name, Middle Name, Last Name, Suffix, Gender
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) => _formFieldSkeleton(
                // Vary the label widths for realism
                labelWidth: [80.0, 90.0, 80.0, 50.0, 60.0][index],
                isDropdown: index == 4, // Gender field is dropdown
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _formFieldSkeleton({
    required double labelWidth,
    bool isDropdown = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _SkeletonBox(width: 16, height: 16, borderRadius: 8),
            const SizedBox(width: 8),
            _SkeletonBox(width: labelWidth, height: 14, borderRadius: 4),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                const Expanded(
                  child: _SkeletonBox(
                    width: double.infinity,
                    height: 16,
                    borderRadius: 4,
                  ),
                ),
                if (isDropdown) ...[
                  const SizedBox(width: 8),
                  const _SkeletonBox(width: 16, height: 16, borderRadius: 4),
                ],
              ],
            ),
          ),
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
      padding: const EdgeInsets.all(16),
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
