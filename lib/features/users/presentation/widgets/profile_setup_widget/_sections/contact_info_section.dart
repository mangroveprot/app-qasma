import 'package:flutter/material.dart';
import '../../../../../../common/helpers/spacing.dart';
import '../../../../../../common/utils/form_field_config.dart';
import '../../../../../../common/widgets/custom_form_field.dart';
import 'phone_number_field.dart';

class ContactInfoSection extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController contactController;
  final TextEditingController emailController;
  final TextEditingController facebookController;

  const ContactInfoSection({
    super.key,
    required this.addressController,
    required this.contactController,
    required this.emailController,
    required this.facebookController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Address
        Row(
          children: [
            CustomFormField(
              field_key: field_address.field_key,
              name: field_address.name,
              hint: field_address.hint,
              controller: addressController,
              required: true,
            ),
          ],
        ),
        Spacing.verticalMedium,

        // Contact + Email
        Row(
          children: [
            CustomFormField(
              field_key: field_email.field_key,
              name: field_email.name,
              hint: field_email.hint,
              controller: emailController,
              required: true,
            ),
          ],
        ),
        Spacing.verticalMedium,
        PhoneNumberField(
          label: field_contact_number.name,
          hint: field_contact_number.hint,
          controller: contactController,
          required: true,
        ),
        Spacing.verticalMedium,
        // Facebook
        Row(
          children: [
            CustomFormField(
              field_key: field_facebook.field_key,
              name: field_facebook.name,
              hint: field_facebook.hint,
              controller: facebookController,
            ),
          ],
        ),
      ],
    );
  }
}
