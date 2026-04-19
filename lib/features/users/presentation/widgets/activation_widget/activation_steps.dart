import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../theme/theme_extensions.dart';

class ActivationSteps extends StatelessWidget {
  const ActivationSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStep(1, 'Visit the Guidance Office during office hours', colors),
        const SizedBox(height: 8),
        _buildStep(2, 'Bring your student ID', colors),
        const SizedBox(height: 8),
        _buildStep(3, 'Present this QR code to the staff member', colors),
        const SizedBox(height: 8),
        _buildStep(4, 'Your account will be activated immediately', colors),
      ],
    );
  }

  Widget _buildStep(int number, String title, AppColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
