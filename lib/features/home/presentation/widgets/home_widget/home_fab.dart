import 'package:flutter/material.dart';

import '../../../../../common/utils/constant.dart';
import '../../../../../common/utils/content_item.dart';
import '../../../../../common/widgets/custom_modal/custom_modal.dart';
import '../../../../../theme/theme_extensions.dart';

class HomeFab extends StatelessWidget {
  const HomeFab({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () async {
            final category = await CustomModal.showSelectionModal(context,
                title: ContentItems.appointmentSelection.title,
                subtitle: ContentItems.appointmentSelection.description,
                options: newAppointmentOptions);
            if (category != null) {
              // Navigate based on selection
              debugPrint(category);
            }
          },
          backgroundColor: colors.primary,
          foregroundColor: colors.white,
          elevation: 4,
          child: const Icon(
            Icons.add,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'New Appointments',
          style: TextStyle(
              fontSize: 12,
              color: colors.textPrimary,
              fontWeight: weight.medium),
        ),
      ],
    );
  }
}
