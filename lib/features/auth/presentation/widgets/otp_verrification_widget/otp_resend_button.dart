import 'package:flutter/material.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class OtpResendButton extends StatelessWidget {
  final VoidCallback onPressedResend;
  const OtpResendButton({super.key, required this.onPressedResend});

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      labelText: 'Resend Code',
      labelTextColor: context.colors.textPrimary,
      labelTextDecoration: TextDecoration.underline,
      onPressedCallback: onPressedResend,
    );
  }
}
