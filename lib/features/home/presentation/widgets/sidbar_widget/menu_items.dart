import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/menu_items_config.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class MenuItem extends StatelessWidget {
  final MenuItemConfig item;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLogout = item.isLogout;

    final colors = context.colors;
    final weight = context.weight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.black.withOpacity(0.05),
        highlightColor: Colors.black.withOpacity(0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: isLogout ? colors.error : colors.black,
                size: 24,
              ),
              Spacing.horizontalMedium,
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: isLogout ? colors.error : colors.black,
                    fontSize: 16,
                    fontWeight: weight.regular,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
