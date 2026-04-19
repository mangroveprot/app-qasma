import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class BookAppointmentButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isRescheduling;
  const BookAppointmentButtons({
    super.key,
    required this.onPressed,
    this.isRescheduling = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;

    // Single neutral label for staff action
    const primaryLabel = 'Confirm';

    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.accent.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: radius.medium,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Cancel'),
            ),
          ),
          Spacing.horizontalMedium,
          Expanded(
            child: CustomTextButton(
              onPressed: onPressed,
              text: primaryLabel,
              backgroundColor: colors.primary,
              borderRadius: radius.medium,
              textColor: colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
