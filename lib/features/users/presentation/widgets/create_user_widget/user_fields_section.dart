import 'package:flutter/material.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/widgets/custom_form_field.dart';

class UserFieldsSection extends StatelessWidget {
  final TextEditingController idNumberController;
  final TextEditingController passwordController;

  const UserFieldsSection({
    super.key,
    required this.idNumberController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ID Number Field
        Row(
          children: [
            CustomFormField(
              field_key: field_idNumber.field_key,
              name: field_idNumber.name,
              required: true,
              controller: idNumberController,
              hint: field_idNumber.hint,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Password Field
        Row(
          children: [
            CustomFormField(
              field_key: field_password.field_key,
              name: field_password.name,
              required: true,
              controller: passwordController,
              hint: field_password.hint,
            ),
          ],
        ),
      ],
    );
  }
}
