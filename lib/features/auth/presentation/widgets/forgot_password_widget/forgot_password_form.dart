import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../pages/forgot_password_page.dart';
import '../get_started_widget/next_button.dart';
import 'email_section.dart';

class ForgotPasswordForm extends StatelessWidget {
  final ForgotPasswordPageState state;
  const ForgotPasswordForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailSection(
              emailController:
                  state.textControllers[field_idNumber_email.field_key]!),
          Spacing.verticalLarge,
          NextButton(onPressed: () => state.handleSubmit(context))
        ],
      ),
    );
  }
}
