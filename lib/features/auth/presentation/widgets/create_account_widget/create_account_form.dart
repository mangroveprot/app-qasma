import 'package:flutter/material.dart';

import '../../../../../common/utils/form_field_config.dart';
import 'birthday_section.dart';
import 'create_account_terms_footer.dart';
import 'personal_info_section.dart';
import 'contact_info_section.dart';
import 'submit_btn.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../pages/create_account_page.dart';
import '../signup_header.dart';

class CreateAccountForm extends StatelessWidget {
  final CreateAccountPageState state;

  const CreateAccountForm({super.key, required this.state});

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
                child: SignupHeader(headingTitle: 'Personal Information!')),
            Spacing.verticalLarge,
            RepaintBoundary(
              child: PersonalInfoSection(
                firstNameController:
                    state.textControllers[field_firstName.field_key]!,
                lastNameController:
                    state.textControllers[field_lastName.field_key]!,
                suffixController:
                    state.textControllers[field_suffix.field_key]!,
                middleNameController:
                    state.textControllers[field_middle_name.field_key]!,
                genderController:
                    state.dropdownControllers[field_gender.field_key]!,
              ),
            ),
            Spacing.verticalMedium,
            RepaintBoundary(
              child: BirthdateSection(
                monthController:
                    state.dropdownControllers[field_month.field_key]!,
                dayController: state.dropdownControllers[field_day.field_key]!,
                yearController:
                    state.dropdownControllers[field_year.field_key]!,
              ),
            ),
            Spacing.verticalMedium,
            RepaintBoundary(
              child: ContactInfoSection(
                addressController:
                    state.textControllers[field_address.field_key]!,
                contactController:
                    state.textControllers[field_contact_number.field_key]!,
                emailController: state.textControllers[field_email.field_key]!,
                facebookController:
                    state.textControllers[field_facebook.field_key]!,
              ),
            ),
            Spacing.verticalMedium,
            RepaintBoundary(
                child: SubmitButton(
              onPressed: () => state.handleSubmit(context),
            )),
            Spacing.verticalMedium,
            const Center(
              child: RepaintBoundary(
                child: CreateAccountTermsFooter(),
              ),
            ),
            Spacing.verticalMedium,
          ],
        ),
      ),
    );
  }
}
