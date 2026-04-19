import 'package:flutter/material.dart';

import '../../infrastructure/routes/app_routes.dart';

class NavItemConfig {
  final String routeName;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool hasNotification;
  final bool isSpecialButton;

  const NavItemConfig({
    required this.routeName,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.hasNotification = false,
    this.isSpecialButton = false,
  });
}

class AppNavigationConfig {
  static List<NavItemConfig> bottomNavItems = [
    const NavItemConfig(
      routeName: Routes.home_path,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    const NavItemConfig(
      routeName: Routes.appointment_history,
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: 'History',
    ),
    const NavItemConfig(
      routeName: '',
      icon: Icons.add,
      selectedIcon: Icons.add,
      label: '',
      isSpecialButton: true,
    ),
    const NavItemConfig(
      routeName: Routes.notifications,
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      label: 'Notifications',
    ),
    const NavItemConfig(
      routeName: Routes.menu_path,
      icon: Icons.menu,
      selectedIcon: Icons.menu,
      label: 'Menu',
    ),
  ];

  static int getIndexFromRoute(String route) {
    final index = bottomNavItems.indexWhere((item) => item.routeName == route);
    return index != -1 ? index : 0;
  }

  static String getRouteFromIndex(int index) {
    if (index >= 0 && index < bottomNavItems.length) {
      return bottomNavItems[index].routeName;
    }
    return bottomNavItems[0].routeName;
  }
}
