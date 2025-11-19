import 'package:flutter/material.dart';

import '../../../../infrastructure/theme/theme_extensions.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final String title;
  final int unreadCount;

  const MainAppBar({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.title = 'GCare',
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final color_white = colors.white;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary,
            colors.primary.withOpacity(0.4),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: colors.primary,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                // Hamburger Menu
                Builder(
                  builder: (BuildContext scaffoldContext) {
                    return SizedBox(
                      width: 40,
                      height: 40,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: radius.medium,
                        child: InkWell(
                          borderRadius: radius.medium,
                          onTap: () {
                            Scaffold.of(scaffoldContext).openDrawer();
                            onMenuTap?.call();
                          },
                          child: Center(
                            child: Icon(
                              Icons.menu,
                              color: color_white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: weight.medium,
                      color: color_white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Notification bell with badge
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      Material(
                        color: Colors.transparent,
                        borderRadius: radius.medium,
                        child: InkWell(
                          borderRadius: radius.medium,
                          onTap: () {
                            if (onNotificationTap != null) {
                              onNotificationTap!();
                            } else {
                              debugPrint('Notification bell tapped');
                            }
                          },
                          child: Center(
                            child: Icon(
                              Icons.notifications_outlined,
                              color: color_white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      // Badge
                      if (unreadCount > 0)
                        // Notification bell with badge
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(
                            clipBehavior: Clip.none, // Allow badge to overflow
                            children: [
                              Material(
                                color: Colors.transparent,
                                borderRadius: radius.medium,
                                child: InkWell(
                                  borderRadius: radius.medium,
                                  onTap: () {
                                    if (onNotificationTap != null) {
                                      onNotificationTap!();
                                    } else {
                                      debugPrint('Notification bell tapped');
                                    }
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      color: color_white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.error,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: colors.primary,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors.black.withOpacity(0.2),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        unreadCount > 99
                                            ? '99+'
                                            : '$unreadCount',
                                        style: TextStyle(
                                          color: colors.white,
                                          fontSize: 10,
                                          fontWeight: weight.bold,
                                          height: 1,
                                          letterSpacing: -0.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
