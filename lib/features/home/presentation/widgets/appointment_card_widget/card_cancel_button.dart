import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class CardCancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CardCancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radii = context.radii;

    return Align(
      alignment: Alignment.centerRight,
      child: IntrinsicWidth(
        child: CustomAppButton(
          height: 44,
          labelText: 'Cancel',
          labelFontSize: 12,
          labelTextColor: colors.white,
          backgroundColor: colors.error,
          labelTextDecoration: TextDecoration.none,
          labelFontWeight: weight.medium,
          borderRadius: radii.medium,
          icon: Icons.cancel,
          iconPosition: Position.left,
          iconSize: 12,
          disabledBackgroundColor: colors.textPrimary,
          contentAlignment: MainAxisAlignment.center,
          onPressedCallback: onPressed,
        ),
      ),
    );
  }
}
