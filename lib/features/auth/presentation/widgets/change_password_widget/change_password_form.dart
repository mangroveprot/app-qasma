import 'package:flutter/cupertino.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../pages/change_password.dart';
import 'change_pass_confirm_button.dart';
import 'change_password_field.dart';

class ChangePasswordForm extends StatelessWidget {
  final ChangePassswordPageState state;
  const ChangePasswordForm({super.key, required this.state});

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
                    child: ChangePasswordField(
                      currentPasswordController: state
                          .textControllers[field_current_password.field_key]!,
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
            child: ChangePassConfirmButton(
              onPressed: () => state.handleSubmit(context),
            ),
          ),
        ],
      ),
    );
  }
}
