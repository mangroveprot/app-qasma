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
  static const String dashboard = 'dashboard';
  static const String myProfile = 'my_profile';
  static const String history = 'history';
  static const String users = 'users';
  static const String privacyPolicy = 'privacy_policy';
  static const String termsAndCondition = 'terms_and_condition';
  static const String settings = 'settings';
  static const String logout = 'logout';
  static const String about = 'about';
}

const List<MenuItemConfig> menu_items = [
  MenuItemConfig(
    menu_key: MenuKeys.dashboard,
    title: 'Dashboard',
    icon: Icons.dashboard_outlined,
  ),
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
    menu_key: MenuKeys.users,
    title: 'Students',
    icon: Icons.people_alt_outlined,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.privacyPolicy,
    title: 'Privacy Policy',
    icon: Icons.shield_outlined,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.termsAndCondition,
    title: 'Terms And Condition',
    icon: Icons.description_outlined,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.settings,
    title: 'Settings',
    icon: Icons.settings_outlined,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.about,
    title: 'About',
    icon: Icons.info_outline,
  ),
  MenuItemConfig(
    menu_key: MenuKeys.logout,
    title: 'Log-out',
    icon: Icons.logout_outlined,
    isLogout: true,
  ),
];
