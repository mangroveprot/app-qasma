import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/appointment_config/domain/entites/category.dart';
import '../../features/appointment_config/presentation/bloc/appointment_config_cubit.dart';
import '../../infrastructure/routes/app_routes.dart';
import '../../theme/theme_extensions.dart';
import '../utils/app_navigation_config.dart';
import 'nav_add_button.dart';
import 'nav_item.dart';

class BottomNavbar extends StatelessWidget {
  final String currentRoute;
  final Function(int)? onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final int unreadNotificationCount;

  const BottomNavbar({
    super.key,
    required this.currentRoute,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.unreadNotificationCount = 0,
  });

  int get _selectedIndex => AppNavigationConfig.getIndexFromRoute(currentRoute);

  void _onItemTapped(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
    } else {
      final route = AppNavigationConfig.getRouteFromIndex(index);
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colors;

    return BlocSelector<AppointmentConfigCubit, AppointmentConfigCubitState,
        Map<String, Category>>(
      selector: (state) {
        if (state is AppointmentConfigLoadedState) {
          return state.config.categoryAndType ?? {};
        }
        return {};
      },
      builder: (context, categories) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              painter: NavbarCutoutPainter(color: color.primary),
              child: SafeArea(
                child: SizedBox(
                  height: 60,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            AppNavigationConfig.bottomNavItems.length,
                            (index) {
                              final item =
                                  AppNavigationConfig.bottomNavItems[index];
                              final isSelected = _selectedIndex == index;

                              if (item.isSpecialButton) {
                                return const SizedBox(width: 70);
                              }

                              final isNotificationsItem =
                                  item.routeName == Routes.notifications;

                              return NavItem(
                                index: index,
                                icon: item.icon,
                                selectedIcon: item.selectedIcon,
                                label: item.label,
                                isSelected: isSelected,
                                onTap: (idx) => _onItemTapped(context, idx),
                                notificationCount: isNotificationsItem
                                    ? unreadNotificationCount
                                    : 0,
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: _selectedIndex ==
                                      AppNavigationConfig.bottomNavItems
                                          .indexWhere(
                                        (item) => item.isSpecialButton,
                                      )
                                  ? color.white
                                  : color.white.withOpacity(0.6),
                              fontSize: 10,
                              fontWeight: _selectedIndex ==
                                      AppNavigationConfig.bottomNavItems
                                          .indexWhere(
                                        (item) => item.isSpecialButton,
                                      )
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              height: 1.1,
                            ),
                            child: Text(
                              AppNavigationConfig.bottomNavItems
                                  .firstWhere(
                                    (item) => item.isSpecialButton,
                                  )
                                  .label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -28,
              child: NavAddButton(
                currentRoute: currentRoute,
                isSelected: _selectedIndex ==
                    AppNavigationConfig.bottomNavItems.indexWhere(
                      (item) => item.isSpecialButton,
                    ),
                label: AppNavigationConfig.bottomNavItems
                    .firstWhere(
                      (item) => item.isSpecialButton,
                    )
                    .label,
              ),
            ),
          ],
        );
      },
    );
  }
}

class NavbarCutoutPainter extends CustomPainter {
  final Color color;

  NavbarCutoutPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path
      ..moveTo(0, size.height)
      ..lineTo(0, 0);

    final centerX = size.width / 2;

    final cutoutRadius = 28.0;
    final cutoutDepth = 1.0;
    final horizontalOffset = 50.0;

    path.lineTo(centerX - cutoutRadius - horizontalOffset, 0);

    path.quadraticBezierTo(
      centerX - cutoutRadius,
      0,
      centerX - cutoutRadius,
      cutoutDepth,
    );

    path.arcToPoint(
      Offset(centerX + cutoutRadius, cutoutDepth),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );

    path.quadraticBezierTo(
      centerX + cutoutRadius,
      0,
      centerX + cutoutRadius + horizontalOffset,
      0,
    );

    path
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NavbarCutoutPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
