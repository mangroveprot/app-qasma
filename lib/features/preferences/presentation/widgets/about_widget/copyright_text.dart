import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class CopyrightText extends StatelessWidget {
  const CopyrightText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentYear = DateTime.now().year;

    return Text(
      '©$currentYear Gcare',
      style: TextStyle(
        fontSize: 11,
        color: colors.textPrimary,
      ),
    );
  }
}
