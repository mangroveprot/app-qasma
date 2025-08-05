import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/widgets/custom_dropdown_field.dart';

class BookTypeDataTimeSection extends StatelessWidget {
  final ValueNotifier<String?> dateAndTimeController;
  final ValueNotifier<String?> appointmentTypeController;

  const BookTypeDataTimeSection({
    super.key,
    required this.dateAndTimeController,
    required this.appointmentTypeController,
  });

  static const List<String> _appointmentTypes = [
    'Individual Counseling',
    'Group Therapy',
    'Family Counseling',
    'Couples Therapy',
    'Crisis Intervention',
    'Online Session',
  ];

  // Static styles for performance
  static const _sectionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const _subtitleStyle = TextStyle(
    fontSize: 12,
    color: Colors.black54,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field_appointmentType.name, style: _sectionTitleStyle),
        Spacing.verticalXSmall,
        const Text(
          'Choose the type of counselling session that best fits your needs.',
          style: _subtitleStyle,
        ),
        Spacing.verticalXSmall,
        Column(
          children: [
            Row(
              children: [
                CustomDropdownField(
                  field_key: field_appointmentType.field_key,
                  name: null,
                  hint: field_appointmentType.hint,
                  controller: appointmentTypeController,
                  items: _appointmentTypes,
                  required: true,
                ),
              ],
            ),
            const _DateTime()
          ],
        )
      ],
    );
  }
}

class _DateTime extends StatelessWidget {
  final ValueNotifier<String?> dateAndTimeController;
  const _DateTime(this.dateAndTimeController);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomDropdownField(
          field_key: field_appointmentDateTime.field_key,
          name: null,
          hint: field_appointmentDateTime.hint,
          controller: dateAndTimeController,
          items: [],
          required: true,
        ),
      ],
    );
  }
}
