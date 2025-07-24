import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class OtpVerifyButton extends StatelessWidget {
  final VoidCallback onPressed;
  const OtpVerifyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      buttonText: 'Verify Account',
      textColor: context.colors.white,
      buttonColor: context.colors.primary,
      textDecoration: TextDecoration.none,
      fontWeight: context.weight.medium,
      borderRadius: context.radii.large,
      disabledBackgroundColor: context.colors.textPrimary,
      mainAxisAlignment: MainAxisAlignment.center,
      buttonHeight: 50,
      onPressed: onPressed,
    );
  }
}
