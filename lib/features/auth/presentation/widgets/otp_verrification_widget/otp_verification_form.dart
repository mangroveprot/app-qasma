import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../pages/otp_verification_page.dart';
import 'otp_build_fields_section.dart';
import 'otp_heder_section.dart';
import 'otp_icon_section.dart';
import 'otp_resend_button.dart';
import 'otp_verify_button.dart';

class OtpVerificationForm extends StatelessWidget {
  final OtpVerificationPageState state;

  const OtpVerificationForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OtpIconSection(),
                Spacing.horizontalLarge,
                OtpHederSection(email: state.getRouteValue(field_email)),
                Spacing.verticalLarge,
                Spacing.verticalLarge,
                OtpBuildFieldsSection(
                  onChanged: state.onOtpChanged,
                  onBackspace: state.onBackspace,
                  onSubmitted: (int) => state.onSubmitted(context, int),
                  fieldKey: state.otp_field_key,
                  controllers: state.controllers,
                  focusNodes: state.focusNodes,
                ),
                Spacing.verticalMedium,
                OtpVerifyButton(
                    onPressed: () => state.handleVerifyOTP(context)),
                Spacing.verticalMedium,
                state.canResendOtp
                    ? OtpResendButton(
                        onPressedResend: () => state.handleResendOTP(context))
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: TextButton(
                          onPressed: null,
                          child: Text(
                            'Resend OTP in ${state.formatResendTime(state.resendCooldownRemaining)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                Spacing.verticalMedium,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
