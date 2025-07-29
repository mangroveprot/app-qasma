import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';
import 'menu_close_button.dart';

class MenuHeader extends StatelessWidget {
  final String user_name;
  const MenuHeader({super.key, required this.user_name});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Container(
      width: double.infinity,
      color: colors.primary,
      padding: const EdgeInsets.fromLTRB(14, 48, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              user_name,
              style: TextStyle(
                color: colors.white,
                fontSize: 18,
                fontWeight: weight.medium,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const MenuCloseButton(),
        ],
      ),
    );
  }
}
