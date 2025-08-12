import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/button_ids.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class OtpVerifyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OtpVerifyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final fontWeight = context.weight;

    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        return CustomAppButton(
          labelText: 'Verify Account',
          labelTextColor: colors.white,
          backgroundColor: colors.primary,
          labelTextDecoration: TextDecoration.none,
          labelFontWeight: fontWeight.medium,
          borderRadius: radii.large,
          disabledBackgroundColor: colors.textPrimary,
          contentAlignment: MainAxisAlignment.center,
          height: 50,
          onPressedCallback: onPressed,
          buttonId: ButtonsUniqeKeys.verify.id,
        );
      },
    );
  }
}
