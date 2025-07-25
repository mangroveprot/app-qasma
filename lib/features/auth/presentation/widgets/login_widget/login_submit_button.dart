import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class LoginSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Builder(
        builder: (context) {
          return CustomAppButton(
            labelText: 'Login',
            labelTextColor: context.colors.white,
            backgroundColor: context.colors.primary,
            labelTextDecoration: TextDecoration.none,
            labelFontWeight: context.weight.medium,
            borderRadius: context.radii.medium,
            disabledBackgroundColor: context.colors.textPrimary,
            contentAlignment: MainAxisAlignment.center,
            onPressedCallback: onPressed,
          );
        },
      ),
    );
  }
}
