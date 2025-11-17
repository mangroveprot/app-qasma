import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';

class CopyrightText extends StatelessWidget {
  const CopyrightText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentYear = DateTime.now().year;

    return Text(
      '©$currentYear GCare',
      style: TextStyle(
        fontSize: 11,
        color: colors.textPrimary,
      ),
    );
  }
}
