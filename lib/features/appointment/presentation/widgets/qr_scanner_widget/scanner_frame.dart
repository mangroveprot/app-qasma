import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class ScannerFrame extends StatefulWidget {
  final bool isScanning;

  const ScannerFrame({
    super.key,
    required this.isScanning,
  });

  @override
  State<ScannerFrame> createState() => _ScannerFrameState();
}

class _ScannerFrameState extends State<ScannerFrame>
    with SingleTickerProviderStateMixin {
  static const double _frameSize = 250.0;
  static const double _cornerSize = 30.0;
  static const double _cornerBorderWidth = 3.0;
  static const double _scanLineHeight = 3.0;

  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void didUpdateWidget(ScannerFrame oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isScanning != oldWidget.isScanning) {
      if (widget.isScanning) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isScanning) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _animationController.repeat(reverse: true);
  }

  void _stopAnimation() {
    _animationController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _frameSize,
      height: _frameSize,
      child: Stack(
        children: [
          ..._buildCornerBrackets(context),
          if (widget.isScanning) _buildScanningLine(context),
        ],
      ),
    );
  }

  List<Widget> _buildCornerBrackets(BuildContext context) {
    final colors = context.colors;
    final borderSide = BorderSide(
      color: colors.white,
      width: _cornerBorderWidth,
    );

    return [
      // Top-left corner
      _buildCorner(
        top: 0,
        left: 0,
        border: Border(top: borderSide, left: borderSide),
      ),
      // Top-right corner
      _buildCorner(
        top: 0,
        right: 0,
        border: Border(top: borderSide, right: borderSide),
      ),
      // Bottom-left corner
      _buildCorner(
        bottom: 0,
        left: 0,
        border: Border(bottom: borderSide, left: borderSide),
      ),
      // Bottom-right corner
      _buildCorner(
        bottom: 0,
        right: 0,
        border: Border(bottom: borderSide, right: borderSide),
      ),
    ];
  }

  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Border border,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: _cornerSize,
        height: _cornerSize,
        decoration: BoxDecoration(border: border),
      ),
    );
  }

  Widget _buildScanningLine(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, child) {
        return Positioned(
          top: _scanLineAnimation.value * (_frameSize - 30) + 15,
          left: 15,
          right: 15,
          child: Container(
            height: _scanLineHeight,
            decoration: BoxDecoration(
              color: colors.primary,
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(0.8),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
