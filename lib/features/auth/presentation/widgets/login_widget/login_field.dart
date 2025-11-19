import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/widgets/custom_form_field.dart';
import '../custom_password_field.dart';
import 'login_forgot_password_btn.dart';

class LoginField extends StatelessWidget {
  final TextEditingController idNumberController;
  final TextEditingController passwordController;

  const LoginField({
    super.key,
    required this.idNumberController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // ID Number Field
          Row(
            children: [
              CustomFormField(
                field_key: field_idNumber.field_key,
                name: 'ID or Username',
                hint: 'Enter your ID or username',
                controller: idNumberController,
                required: true,
              ),
            ],
          ),
          Spacing.verticalSmall,
          // Password Field
          Row(
            children: [
              CustomPasswordField(
                field_key: field_password.field_key,
                name: 'Password',
                hint: 'Enter your password',
                controller: passwordController,
                showErrorText: false,
                showPasswordRule: false,
                required: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerRight,
            child: LoginForgotPasswordBtn(),
          ),
        ],
      ),
    );
  }
}
