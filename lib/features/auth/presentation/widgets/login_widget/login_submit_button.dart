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
      child: CustomAppButton(
        buttonText: 'Login',
        textColor: context.colors.white,
        buttonColor: context.colors.primary,
        textDecoration: TextDecoration.none,
        fontWeight: context.weight.medium,
        borderRadius: context.radii.medium,
        disabledBackgroundColor: context.colors.textPrimary,
        mainAxisAlignment: MainAxisAlignment.center,
        onPressed: onPressed,
      ),
    );
  }
}
