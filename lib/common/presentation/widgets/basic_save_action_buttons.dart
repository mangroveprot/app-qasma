import 'package:flutter/material.dart';

import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class BasicSaveActionButtons extends StatelessWidget {
  const BasicSaveActionButtons({
    super.key,
    this.buttonId,
    required this.onSave,
    required this.onCancel,
  });

  final String? buttonId;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;

    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.textPrimary.withOpacity(0.4),
                  foregroundColor: colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontWeight: fontWeight.medium),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextButton(
                buttonId: buttonId,
                onPressed: onSave,
                text: 'Save',
                textColor: colors.white,
                fontSize: 14,
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: colors.primary,
                borderRadius: radius.medium,
                iconData: Icons.save_outlined,
                iconSize: 14,
                iconPosition: Position.left,
              ),
            ),
          ],
        ),
      );
    });
  }
}
