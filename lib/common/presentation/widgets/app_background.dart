import 'package:flutter/material.dart';
import 'triangle_painter.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8E8E8),
      child: Stack(
        children: [
          // left triangle gradient
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: ClipPath(
              clipper: LeftTriangleClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, 0.0),
                    radius: 1.0,
                    colors: [
                      const Color(0xFFB8E6A3).withOpacity(0.5),
                      const Color(0xFFB8E6A3).withOpacity(0.3),
                      const Color(0xFFB8E6A3).withOpacity(0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // right top triangle gradient
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: ClipPath(
              clipper: RightTriangleClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.3, -0.5),
                    radius: 1.0,
                    colors: [
                      const Color(0xFFB8E6A3).withOpacity(0.5),
                      const Color(0xFFB8E6A3).withOpacity(0.3),
                      const Color(0xFFB8E6A3).withOpacity(0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // bottom right triangle gradient
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomRightTriangleClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.5, 0.5),
                    radius: 0.8,
                    colors: [
                      const Color(0xFFB8E6A3).withOpacity(0.5),
                      const Color(0xFFB8E6A3).withOpacity(0.3),
                      const Color(0xFFB8E6A3).withOpacity(0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // small rotated square accent
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Transform.rotate(
              angle: 0.4,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8E6A3).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          // child content
          child,
        ],
      ),
    );
  }
}
