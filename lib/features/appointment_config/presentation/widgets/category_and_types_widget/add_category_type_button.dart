import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class AddCategoryTypeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCategoryTypeButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'Add Reminder',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.white,
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.textPrimary, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}
