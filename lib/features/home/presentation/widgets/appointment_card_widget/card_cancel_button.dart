import 'package:flutter/material.dart';

import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class CardCancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonId;
  const CardCancelButton(
      {super.key, required this.onPressed, required this.buttonId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radii = context.radii;

    return CustomTextButton(
      buttonId: buttonId,
      height: 44,
      width: double.infinity,
      text: 'Cancel',
      fontSize: 14,
      textColor: colors.white,
      backgroundColor: colors.error,
      textDecoration: TextDecoration.none,
      fontWeight: weight.medium,
      borderRadius: radii.medium,
      iconData: Icons.close_outlined,
      iconPosition: Position.left,
      iconColor: colors.white,
      iconSize: 14,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      onPressed: onPressed,
    );
  }
}
