import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../theme/theme_extensions.dart';

class BookAppointmentButtons extends StatelessWidget {
  const BookAppointmentButtons({super.key});

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
          CustomTextButton(
            onPressed: () {
              context.pop();
            },
            text: 'Cancel',
            textDecoration: TextDecoration.underline,
            borderRadius: radius.medium,
          ),
          Spacing.horizontalMedium,
          CustomTextButton(
            onPressed: () {},
            text: 'Appoint Now',
            backgroundColor: colors.primary,
            borderRadius: radius.medium,
            textColor: colors.white,
          ),
        ],
      ),
    );
  }
}
