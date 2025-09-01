import 'package:flutter/material.dart';

import '../../../../../../common/utils/form_field_config.dart';
import '../../../controller/profile_setup_controller.dart';
import 'reusbale_section.dart';

class ReviewStepSection extends StatelessWidget {
  final ProfileSetupController controller;

  const ReviewStepSection({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StepHeader(
          icon: Icons.check,
          iconColor: Colors.purple,
          title: 'Review Your Information',
        ),
        _buildReviewNote(),
        const SizedBox(height: 16),
        _buildPersonalInfoReview(),
        const SizedBox(height: 16),
        _buildContactInfoReview(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPersonalInfoReview() {
    return ReviewCard(
      title: 'Personal Information',
      children: [
        Text('Name: ${controller.getFullName()}',
            style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text('Gender: ${controller.getDropdownValue(field_gender)}',
            style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text('Date of Birth: ${controller.getBirthDate()}',
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildContactInfoReview() {
    final email = controller.getTextValue(field_email);
    final phone = controller.getTextValue(field_contact_number);
    final address = controller.getTextValue(field_address);
    final facebook = controller.getTextValue(field_facebook);

    return ReviewCard(
      title: 'Contact Information',
      children: [
        Text('Email: $email', style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text('Phone: $phone', style: const TextStyle(fontSize: 14)),
        if (address.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text('Address: $address', style: const TextStyle(fontSize: 14)),
        ],
        if (facebook.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text('Facebook: $facebook', style: const TextStyle(fontSize: 14)),
        ],
      ],
    );
  }

  Widget _buildReviewNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Please review your information carefully. You can go back to make changes if needed.',
        style: TextStyle(
          color: Colors.blue[800],
          fontSize: 13,
        ),
      ),
    );
  }
}
