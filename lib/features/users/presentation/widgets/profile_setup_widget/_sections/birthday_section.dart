import 'package:flutter/material.dart';

import '../../../../../../common/helpers/spacing.dart';
import '../../../../../../common/utils/constant.dart';
import '../../../../../../common/utils/form_field_config.dart';
import '../../../../../../common/widgets/custom_dropdown_field.dart';
import '../../../../../../infrastructure/theme/theme_extensions.dart';

class BirthdateSection extends StatelessWidget {
  final ValueNotifier<String?> monthController;
  final ValueNotifier<String?> dayController;
  final ValueNotifier<String?> yearController;

  const BirthdateSection({
    super.key,
    required this.monthController,
    required this.dayController,
    required this.yearController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Birthdate:',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 14,
            fontWeight: context.weight.medium,
          ),
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            CustomDropdownField(
              field_key: field_month.field_key,
              name: field_month.name,
              hint: field_month.hint,
              showErrorText: false,
              required: true,
              controller: monthController,
              items: monthsList,
            ),
            Spacing.horizontalXSmall,
            CustomDropdownField(
              field_key: field_day.field_key,
              name: field_day.name,
              hint: field_day.hint,
              required: true,
              showErrorText: false,
              controller: dayController,
              items: daysList,
            ),
            Spacing.horizontalXSmall,
            CustomDropdownField(
              field_key: field_year.field_key,
              name: field_year.name,
              hint: field_year.hint,
              required: true,
              showErrorText: false,
              controller: yearController,
              items: yearsList,
            ),
          ],
        ),
      ],
    );
  }
}
