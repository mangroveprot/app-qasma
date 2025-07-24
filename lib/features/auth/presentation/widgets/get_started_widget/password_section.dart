import 'package:flutter/material.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../custom_password_field.dart';

class PasswordSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PasswordSection({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomPasswordField(
              field_key: field_password.field_key,
              name: field_password.name,
              hint: field_password.hint,
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
