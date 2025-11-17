import 'package:flutter/material.dart';

import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../theme/theme_extensions.dart';

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
      fontSize: 13,
      textColor: colors.error,
      backgroundColor: Colors.transparent,
      textDecoration: TextDecoration.none,
      fontWeight: weight.medium,
      borderRadius: radii.medium,
      border: Border.all(color: colors.error, width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      onPressed: onPressed,
    );
  }
}
