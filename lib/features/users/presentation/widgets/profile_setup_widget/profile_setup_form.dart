import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../pages/profile_setup_page.dart';
import '_sections/contact_info_section.dart';
import '_sections/profile_header_section.dart';
import '_sections/profile_info_section.dart';
import '_sections/reusbale_section.dart';
import '_sections/review_section.dart';

class PagesetupForm extends StatelessWidget {
  final ProfileSetupPageState state;
  const PagesetupForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Fixed header section (non-scrollable)
          const ProfileHeaderSection(),
          Spacing.verticalMedium,
          CustomProgressIndicator(
            currentStep: state.currentStep,
            totalSteps: state.totalSteps,
          ),
          Spacing.verticalLarge,
          // Scrollable content area
          Expanded(
            child: _buildFormContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Column(
      children: [
        // Main form content - takes available space
        Expanded(
          child: PageView(
            controller: state.controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildSteps(),
          ),
        ),

        // Fixed bottom section (always visible)
        _buildBottomSection(context),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: NavigationButtons(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
          onPrevious: state.currentStep == 0 ? null : state.prevStep,
          onNext: () => state.nextStep(context),
          onComplete: () => state.completeSetup(context),
        ),
      ),
    );
  }

  List<Widget> _buildSteps() {
    return [
      SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: PersonalInfoSection(
          firstNameController:
              state.controller.textControllers[field_firstName.field_key]!,
          lastNameController:
              state.controller.textControllers[field_lastName.field_key]!,
          suffixController:
              state.controller.textControllers[field_suffix.field_key]!,
          middleNameController:
              state.controller.textControllers[field_middle_name.field_key]!,
          genderController:
              state.controller.dropdownControllers[field_gender.field_key]!,
          dayController:
              state.controller.dropdownControllers[field_day.field_key]!,
          monthController:
              state.controller.dropdownControllers[field_month.field_key]!,
          yearController:
              state.controller.dropdownControllers[field_year.field_key]!,
        ),
      ),
      SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: ContactInfoSection(
          addressController:
              state.controller.textControllers[field_address.field_key]!,
          contactController:
              state.controller.textControllers[field_contact_number.field_key]!,
          emailController:
              state.controller.textControllers[field_email.field_key]!,
          facebookController:
              state.controller.textControllers[field_facebook.field_key]!,
        ),
      ),
      SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: ReviewStepSection(controller: state.controller),
      ),
    ];
  }
}
