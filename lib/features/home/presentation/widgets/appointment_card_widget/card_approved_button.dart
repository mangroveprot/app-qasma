import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class CardApproveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonId;
  const CardApproveButton(
      {super.key, required this.onPressed, required this.buttonId});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radii = context.radii;

    return Builder(builder: (context) {
      return CustomAppButton(
        buttonId: buttonId,
        height: 44,
        width: double.infinity,
        labelText: 'Approve',
        labelFontSize: 12,
        labelTextColor: colors.white,
        backgroundColor: colors.primary,
        labelTextDecoration: TextDecoration.none,
        labelFontWeight: weight.medium,
        borderRadius: radii.medium,
        disabledBackgroundColor: colors.textPrimary,
        icon: Icons.check_outlined,
        iconSize: 12,
        loadingSpinnerSize: 12,
        iconPosition: Position.left,
        contentAlignment: MainAxisAlignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        onPressedCallback: onPressed,
      );
    });
  }
}
