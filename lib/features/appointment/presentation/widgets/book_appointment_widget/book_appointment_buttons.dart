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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Spacing.horizontalMedium,
          CustomTextButton(
            onPressed: onPressed,
            text: isRescheduling ? 'Reschedule' : 'Appoint Now',
            backgroundColor: colors.primary,
            borderRadius: radius.medium,
            textColor: colors.white,
          ),
        ],
      ),
    );
  }
}
