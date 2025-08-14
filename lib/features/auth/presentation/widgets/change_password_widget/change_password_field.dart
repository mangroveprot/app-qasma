import 'package:flutter/material.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../custom_password_field.dart';

class ChangePasswordField extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ChangePasswordField({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.currentPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomPasswordField(
              field_key: field_current_password.field_key,
              name: field_current_password.name,
              hint: field_current_password.hint,
              controller: currentPasswordController,
              showPasswordRule: false,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CustomPasswordField(
              field_key: field_password.field_key,
              name: 'New Password',
              hint: 'Enter your new password here...',
              controller: passwordController,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CustomPasswordField(
              field_key: field_confirm_password.field_key,
              name: field_confirm_password.name,
              hint: field_confirm_password.hint,
              controller: confirmPasswordController,
              showPasswordRule: false,
            ),
          ],
        ),
      ],
    );
  }
}
