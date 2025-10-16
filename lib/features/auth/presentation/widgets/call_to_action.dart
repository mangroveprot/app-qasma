import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme/theme_extensions.dart';

class CallToAction extends StatelessWidget {
  final String actionText;
  final String actionLabel;
  final String directionPath;

  const CallToAction({
    super.key,
    required this.actionText,
    required this.actionLabel,
    required this.directionPath,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: actionText,
              style: TextStyle(color: context.colors.textPrimary),
            ),
            TextSpan(
              text: actionLabel,
              style: TextStyle(
                color: colors.secondary,
                fontWeight: context.weight.bold,
                decoration: TextDecoration.none,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.go(directionPath);
                },
            ),
          ],
        ),
      ),
    );
  }
}
