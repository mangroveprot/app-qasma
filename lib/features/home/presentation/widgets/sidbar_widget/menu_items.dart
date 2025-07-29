import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../common/utils/menu_items_config.dart';
import '../../../../../theme/theme_extensions.dart';

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

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.accent.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.black.withOpacity(0.1),
          highlightColor: Colors.black.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      ),
    );
  }
}
