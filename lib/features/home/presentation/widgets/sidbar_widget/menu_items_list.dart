import 'package:flutter/material.dart';

import '../../../../../common/utils/menu_items_config.dart';
import 'menu_items.dart';

// ignore: unused_element
class MenuItemsList extends StatelessWidget {
  final Function(String) onMenuItemTap;
  const MenuItemsList({
    super.key,
    required this.onMenuItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: menu_items.length,
      itemBuilder: (context, index) {
        final item = menu_items[index];
        return MenuItem(
          item: item,
          onTap: () => onMenuItemTap(item.menu_key),
        );
      },
    );
  }
}
