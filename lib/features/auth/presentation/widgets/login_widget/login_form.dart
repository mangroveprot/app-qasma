import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../pages/login_page.dart';
import 'login_create_account.dart';
import 'login_field.dart';
import 'login_forgot_password_btn.dart';
import 'login_header.dart';
import 'login_logo.dart';
import 'login_submit_button.dart';

class LoginForm extends StatelessWidget {
  final LoginPageState state;
  const LoginForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacing.horizontalLarge,
              const RepaintBoundary(child: LoginLogo()),
              Spacing.verticalSmall,
              const RepaintBoundary(child: LoginHeader()),
              Spacing.verticalLarge,
              RepaintBoundary(
                child: LoginField(
                  idNumberController:
                      state.textControllers[field_idNumber.field_key]!,
                  passwordController:
                      state.textControllers[field_password.field_key]!,
                ),
              ),
              RepaintBoundary(
                child: LoginSubmitButton(
                    onPressed: () => state.handleSubmit(context)),
              ),
              const RepaintBoundary(child: LoginForgotPasswordBtn()),
              const RepaintBoundary(child: LoginCreateAccountButton()),
            ],
          ),
        ),
      ),
    );
  }
}
