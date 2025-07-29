import 'package:flutter/material.dart';

import '../../../../common/helpers/spacing.dart';
import '../../../../common/utils/menu_items_config.dart';
import '../../../../theme/theme_extensions.dart';

class CustomSidebar extends StatelessWidget {
  final String userName;
  final Function(String)? onMenuItemTap;

  const CustomSidebar({
    super.key,
    this.userName = 'Jane Doe',
    this.onMenuItemTap,
  });

  void _handleMenuTap(BuildContext context, String menuItem) {
    // delay to let the ripple effect show
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });

    if (onMenuItemTap != null) {
      onMenuItemTap!(menuItem);
    }

    return;
  }

  Widget _buildMenuItem(BuildContext context, MenuItemConfig item) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radius = context.radii;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: colors.white,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleMenuTap(context, item.menu_key),
            splashColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: item.isLogout ? Colors.red : colors.black,
                    size: 24,
                  ),
                  Spacing.horizontalMedium,
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: item.isLogout ? Colors.red : colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Custom drawer animation settings
      elevation: 16,
      child: RepaintBoundary(
        child: Column(
          children: [
            // Header
            RepaintBoundary(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF4CAF50),
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.of(context).pop(),
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.1),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildMenuItem(context, menu_items[0]),
                      _buildMenuItem(context, menu_items[1]),
                      _buildMenuItem(context, menu_items[2]),
                      _buildMenuItem(context, menu_items[3]),
                      _buildMenuItem(context, menu_items[4]),
                      _buildMenuItem(context, menu_items[5]),
                      _buildMenuItem(context, menu_items[6]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
