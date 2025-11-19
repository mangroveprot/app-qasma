import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class LoginSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CustomAppButton(
          labelText: 'Sign in',
          labelTextColor: context.colors.white,
          backgroundColor: context.colors.primary,
          labelTextDecoration: TextDecoration.none,
          labelFontWeight: context.weight.medium,
          borderRadius: context.radii.medium,
          disabledBackgroundColor: context.colors.textPrimary,
          contentAlignment: MainAxisAlignment.center,
          onPressedCallback: onPressed,
        ));
  }
}
