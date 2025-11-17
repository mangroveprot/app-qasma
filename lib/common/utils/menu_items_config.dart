import 'package:flutter/material.dart';

class MenuItemConfig {
  final String menu_key;
  final String title;
  final IconData icon;
  final bool isLogout;

  const MenuItemConfig({
    required this.menu_key,
    required this.title,
    required this.icon,
    this.isLogout = false,
  });
}

class MenuKeys {
  static const String myProfile = 'my_profile';
  static const String history = 'history';
  static const String settings = 'settings';
  static const String logout = 'logout';
  static const String about = 'about';
  static const String helpAndSupport = 'help_and_support';
  static const String feedback = 'feedback';
}

const List<MenuItemConfig> menu_items = [
  MenuItemConfig(
    menu_key: MenuKeys.myProfile,
    title: 'My profile',
    icon: Icons.person_outline,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.history,
    title: 'History',
    icon: Icons.history,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.feedback,
    title: 'Feedback',
    icon: Icons.feedback_outlined,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.about,
    title: 'About',
    icon: Icons.info_outline,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.settings,
    title: 'Settings',
    icon: Icons.settings_outlined,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.helpAndSupport,
    title: 'Help and Support',
    icon: Icons.help_outline,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.logout,
    title: 'Log-out',
    icon: Icons.logout_outlined,
    isLogout: true,
  ),
];
