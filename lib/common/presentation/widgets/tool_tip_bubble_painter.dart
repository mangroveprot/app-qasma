import 'package:flutter/material.dart';

class TooltipBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final path = Path();

    final pointerWidth = 10.0;
    final pointerHeight = 12.0;
    final pointerOffset = size.width - 16.0;

    path.moveTo(pointerOffset, 0);
    path.lineTo(pointerOffset - pointerWidth / 2, pointerHeight);
    path.lineTo(pointerOffset + pointerWidth / 2, pointerHeight);
    path.close();

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
