import 'package:flutter/material.dart';
import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      buttonText: 'Create account',
      textColor: context.colors.white,
      buttonColor: context.colors.primary,
      textDecoration: TextDecoration.none,
      fontWeight: context.weight.medium,
      borderRadius: context.radii.medium,
      disabledBackgroundColor: context.colors.textPrimary,
      mainAxisAlignment: MainAxisAlignment.center,
      onPressed: onPressed,
    );
  }
}
