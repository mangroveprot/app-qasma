import 'package:flutter/material.dart';
import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class ResetConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResetConfirmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CustomAppButton(
        labelText: 'Confirm',
        labelTextColor: context.colors.white,
        backgroundColor: context.colors.primary,
        labelTextDecoration: TextDecoration.none,
        labelFontWeight: context.weight.medium,
        borderRadius: context.radii.medium,
        disabledBackgroundColor: context.colors.textPrimary,
        contentAlignment: MainAxisAlignment.center,
        onPressedCallback: onPressed,
      );
    });
  }
}
