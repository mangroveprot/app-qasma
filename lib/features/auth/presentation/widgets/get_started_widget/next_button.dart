import 'package:flutter/material.dart';

import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorToUse = context.colors.textPrimary;

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 100,
        child: CustomTextButton(
          text: 'Next',
          textColor: colorToUse,
          fontSize: 16,
          borderRadius: context.radii.medium,
          textDecoration: TextDecoration.underline,
          fontWeight: context.weight.medium,
          iconData: Icons.arrow_forward,
          iconColor: colorToUse,
          iconPosition: Position.right,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
