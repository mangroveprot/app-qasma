import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class AboutFooter extends StatelessWidget {
  const AboutFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      'QASMA - Developed for JRMSU-KC Guidance Office • Version 1.0.0 • August 2025',
      style: TextStyle(
        color: colors.textPrimary,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
