import 'package:flutter/material.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../common/widgets/custom_form_field.dart';
import '../../../../../common/widgets/custom_dropdown_field.dart';
import '../../../../../common/utils/form_field_config.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController suffixController;
  final TextEditingController middleNameController;
  final ValueNotifier<String?> genderController;

  const PersonalInfoSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.suffixController,
    required this.middleNameController,
    required this.genderController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Name + Last Name
        Row(
          children: [
            Expanded(
              child: CustomFormField(
                field_key: field_firstName.field_key,
                name: field_firstName.name,
                required: true,
                hint: field_firstName.hint,
                controller: firstNameController,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomFormField(
                field_key: field_lastName.field_key,
                name: field_lastName.name,
                required: true,
                hint: field_lastName.hint,
                controller: lastNameController,
              ),
            ),
          ],
        ),
        Spacing.verticalMedium,

        // Suffix + Middle Name + Gender
        Row(
          children: [
            Expanded(
              child: CustomFormField(
                field_key: field_suffix.field_key,
                name: field_suffix.name,
                hint: field_suffix.hint,
                controller: suffixController,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomFormField(
                field_key: field_middle_name.field_key,
                name: field_middle_name.name,
                hint: field_middle_name.hint,
                controller: middleNameController,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomDropdownField(
                field_key: field_gender.field_key,
                name: field_gender.name,
                hint: field_gender.hint,
                required: true,
                showErrorText: false,
                controller: genderController,
                items: genderList,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
