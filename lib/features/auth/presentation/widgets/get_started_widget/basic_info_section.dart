import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/widgets/custom_dropdown_field.dart';
import '../../../../../common/widgets/custom_form_field.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController idNumberController;
  final ValueNotifier<String?> courseController;
  final ValueNotifier<String?> blockController;
  final ValueNotifier<String?> yearLevelController;

  const BasicInfoSection({
    super.key,
    required this.idNumberController,
    required this.courseController,
    required this.blockController,
    required this.yearLevelController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomFormField(
              field_key: field_idNumber.field_key,
              name: field_idNumber.name,
              required: true,
              hint: field_idNumber.hint,
              controller: idNumberController,
            ),
          ],
        ),
        Spacing.verticalMedium,
        Row(
          children: [
            CustomDropdownField(
              field_key: field_course.field_key,
              name: field_course.name,
              hint: field_course.hint,
              required: true,
              controller: courseController,
              items: courseList,
            ),
          ],
        ),
        Spacing.verticalMedium,
        Row(
          children: [
            CustomDropdownField(
              field_key: field_block.field_key,
              name: field_block.name,
              hint: field_block.hint,
              required: true,
              showErrorText: false,
              controller: blockController,
              items: blockList,
            ),
            Spacing.horizontalMedium,
            CustomDropdownField(
              field_key: field_year_level.field_key,
              name: field_year_level.name,
              hint: field_year_level.hint,
              controller: yearLevelController,
              required: true,
              showErrorText: false,
              items: yearLevelList,
            ),
          ],
        ),
      ],
    );
  }
}
