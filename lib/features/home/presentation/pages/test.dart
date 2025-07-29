import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../common/widgets/models/modal_option.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ModalOption> _modalOptions = [
      const ModalOption(
        value: 'counseling',
        title: 'Counseling',
        subtitle:
            'Get support through emotional, mental, or personal challenges with our counseling staff',
        icon: Icon(Icons.psychology, size: 40, color: Colors.blue),
      ),
      const ModalOption(
        value: 'testing',
        title: 'Testing',
        subtitle:
            'Take psychological tests to better understand your mental health and create personalized plans',
        icon: Icon(Icons.assignment, size: 40, color: Colors.green),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await CustomModal.showConfirmDialog(
                context,
                title: 'Delete Account',
                message: 'This will permanently delete your account.',
              );

              if (result == true) {
                // Handle account deletion
              }
            },
            child: const Text('Delete Account'),
          ),
          ElevatedButton(
            onPressed: () async {
              final category = await CustomModal.showSelectionModal(context,
                  options: _modalOptions);

              if (category != null) {
                // Navigate based on selection
                debugPrint(category);
              }
            },
            child: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
}
