import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class CardRescheduleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CardRescheduleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radii = context.radii;

    return Align(
      alignment: Alignment.centerRight,
      child: IntrinsicWidth(
        child: CustomAppButton(
          height: 44,
          labelText: 'Reschedule',
          labelFontSize: 12,
          labelTextColor: colors.white,
          backgroundColor: colors.secondary,
          labelTextDecoration: TextDecoration.none,
          labelFontWeight: weight.medium,
          borderRadius: radii.medium,
          disabledBackgroundColor: colors.textPrimary,
          icon: Icons.edit_calendar,
          iconSize: 12,
          iconPosition: Position.left,
          contentAlignment: MainAxisAlignment.center,
          onPressedCallback: onPressed,
        ),
      ),
    );
  }
}
