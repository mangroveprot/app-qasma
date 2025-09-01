import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';

class CardRescheduleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonId;
  const CardRescheduleButton({
    super.key,
    required this.onPressed,
    required this.buttonId,
  });

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
        labelText: 'Reschedule',
        labelFontSize: 9,
        labelTextColor: colors.white,
        backgroundColor: colors.secondary,
        labelTextDecoration: TextDecoration.none,
        labelFontWeight: weight.medium,
        borderRadius: radii.medium,
        disabledBackgroundColor: colors.textPrimary,
        icon: Icons.schedule,
        iconSize: 10,
        iconPosition: Position.left,
        loadingSpinnerSize: 10,
        contentAlignment: MainAxisAlignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        onPressedCallback: () async {
          final cubit = context.read<ButtonCubit>();
          cubit.emitLoading(
            buttonId: buttonId,
          );
          await Future.delayed(const Duration(milliseconds: 500));
          onPressed();
          cubit.emitInitial();
        },
      );
    });
  }
}
