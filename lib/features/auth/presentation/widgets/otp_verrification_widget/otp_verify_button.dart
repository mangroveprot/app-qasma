import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class OtpVerifyButton extends StatelessWidget {
  final VoidCallback onPressed;
  const OtpVerifyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      labelText: 'Verify Account',
      labelTextColor: context.colors.white,
      backgroundColor: context.colors.primary,
      labelTextDecoration: TextDecoration.none,
      labelFontWeight: context.weight.medium,
      borderRadius: context.radii.large,
      disabledBackgroundColor: context.colors.textPrimary,
      contentAlignment: MainAxisAlignment.center,
      height: 50,
      onPressedCallback: onPressed,
    );
  }
}
