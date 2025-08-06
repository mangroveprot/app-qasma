import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../../../../infrastructure/routes/app_routes.dart';
import '../../pages/get_started_page.dart';
import '../call_to_action.dart';
import '../signup_header.dart';
import 'basic_info_section.dart';
import 'next_button.dart';
import 'password_section.dart';

class GetStartedForm extends StatelessWidget {
  final GetStartedPageState state;
  const GetStartedForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RepaintBoundary(
                child: SignupHeader(headingTitle: 'Get Started!')),
            Spacing.verticalLarge,
            RepaintBoundary(
              child: BasicInfoSection(
                idNumberController:
                    state.textControllers[field_idNumber.field_key]!,
                courseController:
                    state.dropdownControllers[field_course.field_key]!,
                blockController:
                    state.dropdownControllers[field_block.field_key]!,
                yearLevelController:
                    state.dropdownControllers[field_year_level.field_key]!,
              ),
            ),
            Spacing.verticalMedium,
            RepaintBoundary(
              child: PasswordSection(
                passwordController:
                    state.textControllers[field_password.field_key]!,
                confirmPasswordController:
                    state.textControllers[field_confirm_password.field_key]!,
              ),
            ),
            Spacing.verticalMedium,
            RepaintBoundary(
                child: NextButton(
              onPressed: () => state.handleSubmit(context),
            )),
            Spacing.verticalMedium,
            RepaintBoundary(
              child: CallToAction(
                actionText: 'Already have an account?',
                actionLabel: 'Login',
                directionPath: Routes.buildPath(Routes.aut_path, Routes.login),
              ),
            ),
            Spacing.verticalMedium,
          ],
        ),
      ),
    );
  }
}
