import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> fields;

  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colors.secondary, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: fontWeight.bold,
                color: colors.black.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...fields,
      ],
    );
  }
}
