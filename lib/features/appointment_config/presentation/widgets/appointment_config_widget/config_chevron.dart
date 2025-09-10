import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/widgets/custom_chevron_button.dart';

class ConfigChevron extends StatelessWidget {
  final String type;
  final String? subtitle;
  final IconData icons;
  final VoidCallback onPressed;
  const ConfigChevron({
    super.key,
    required this.type,
    required this.icons,
    required this.onPressed,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomChevronButton(
      title: capitalizeWords(type),
      subtitle: subtitle,
      onTap: onPressed,
      icon: icons,
    );
  }
}
