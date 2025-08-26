import 'package:flutter/material.dart';
import '../../../../../common/utils/button_ids.dart';
import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class DashboardDownloadReportsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DashboardDownloadReportsButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    return Builder(builder: (context) {
      return CustomAppButton(
        buttonId: ButtonsUniqeKeys.downloadReports.id,
        labelText: 'Generate Report',
        labelTextColor: colors.white,
        backgroundColor: colors.primary,
        labelTextDecoration: TextDecoration.none,
        labelFontWeight: weight.medium,
        icon: Icons.file_download,
        iconPosition: Position.left,
        borderRadius: context.radii.medium,
        disabledBackgroundColor: colors.textPrimary,
        contentAlignment: MainAxisAlignment.center,
        onPressedCallback: onPressed,
      );
    });
  }
}
