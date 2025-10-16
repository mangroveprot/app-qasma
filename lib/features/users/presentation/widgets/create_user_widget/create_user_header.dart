import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class CreateUserHeader extends StatelessWidget {
  final String headingTitle;
  const CreateUserHeader({super.key, required this.headingTitle});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
            Text(
              ' *',
              style: TextStyle(
                color: colors.error,
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
