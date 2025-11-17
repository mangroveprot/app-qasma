import 'package:flutter/material.dart';

import 'menu_header.dart';
import 'menu_items_list.dart';

class CustomSidebar extends StatelessWidget {
  final String userName;
  final String idNumber;
  final Function(String)? onMenuItemTap;

  const CustomSidebar({
    super.key,
    required this.userName,
    this.onMenuItemTap,
    required this.idNumber,
  });

  void _handleMenuTap(BuildContext context, String menuKey) {
    Navigator.of(context).pop();
    onMenuItemTap?.call(menuKey);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          MenuHeader(
            user_name: userName,
            idNumber: idNumber,
          ),
          Expanded(
            child: MenuItemsList(
              onMenuItemTap: (menuKey) => _handleMenuTap(context, menuKey),
            ),
          ),
        ],
      ),
    );
  }
}
