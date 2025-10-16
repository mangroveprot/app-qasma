import 'package:flutter/material.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/widgets/custom_form_field.dart';

class EmailSection extends StatelessWidget {
  final TextEditingController emailController;

  const EmailSection({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomFormField(
              field_key: field_idNumber_email.field_key,
              name: field_idNumber_email.name,
              required: true,
              controller: emailController,
              hint: field_idNumber_email.hint,
            ),
          ],
        ),
      ],
    );
  }
}
