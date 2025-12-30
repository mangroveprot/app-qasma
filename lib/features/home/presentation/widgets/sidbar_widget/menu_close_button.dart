import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class MenuCloseButton extends StatelessWidget {
  const MenuCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    return SizedBox(
      width: 54,
      height: 54,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius.large,
        child: InkWell(
          borderRadius: radius.large,
          onTap: () => Navigator.of(context).pop(),
          splashColor: colors.white.withOpacity(0.2),
          highlightColor: colors.white.withOpacity(0.1),
          child: Icon(
            Icons.close,
            color: colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
