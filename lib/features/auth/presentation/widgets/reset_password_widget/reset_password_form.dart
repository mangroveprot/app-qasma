import 'package:flutter/material.dart';
import 'reset_confirm_button.dart';
import 'reset_password_field.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../pages/reset_password_page.dart';

class ResetPasswordForm extends StatelessWidget {
  final ResetPassswordPageState state;
  const ResetPasswordForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    child: ResetPasswordField(
                      passwordController:
                          state.textControllers[field_password.field_key]!,
                      confirmPasswordController: state
                          .textControllers[field_confirm_password.field_key]!,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RepaintBoundary(
            child: ResetConfirmButton(
              onPressed: () => state.handleSubmit(context),
            ),
          ),
        ],
      ),
    );
  }
}
