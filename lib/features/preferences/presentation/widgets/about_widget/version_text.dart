import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class VersionText extends StatelessWidget {
  final String? currentVersion;
  final String? currentBuild;

  const VersionText({
    Key? key,
    this.currentVersion,
    this.currentBuild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      'v${currentVersion ?? '1.0.0'}-build${currentBuild ?? '1'}',
      style: TextStyle(
        fontSize: 13,
        color: colors.textPrimary,
      ),
    );
  }
}
