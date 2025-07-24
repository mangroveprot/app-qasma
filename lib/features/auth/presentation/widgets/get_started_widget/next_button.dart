import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 100,
        child: CustomAppButton(
          buttonText: 'Next',
          textDecoration: TextDecoration.underline,
          fontWeight: context.weight.medium,
          iconData: Icons.arrow_forward,
          iconPosition: Position.right,
          mainAxisAlignment: MainAxisAlignment.end,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
