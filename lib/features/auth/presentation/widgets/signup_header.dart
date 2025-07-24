import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  final String headingTitle;
  const SignupHeader({super.key, required this.headingTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headingTitle,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Required fields are marked with an asterisk',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
