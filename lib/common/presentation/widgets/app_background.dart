import 'package:flutter/material.dart';

import '../../../theme/theme_extensions.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: _BackgroundImage(),
        ),
        child,
      ],
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.white,
          image: const DecorationImage(
            image: AssetImage('assets/images/app_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
