import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/button_ids.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class OtpResendButton extends StatelessWidget {
  final VoidCallback onPressedResend;

  const OtpResendButton({super.key, required this.onPressedResend});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;

    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.center,
          child: CustomTextButton(
            text: 'Resend Code',
            textColor: colors.textPrimary,
            textDecoration: TextDecoration.underline,
            onPressed: onPressedResend,
            borderRadius: radius.large,
            buttonId: ButtonsUniqeKeys.resend.id,
          ),
        );
      },
    );
  }
}
