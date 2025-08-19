import 'package:flutter/material.dart';

import '../../../../infrastructure/theme/theme_extensions.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final String title;

  const MainAppBar({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.title = 'JRMSU-KC QASMA',
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                // Hamburger Menu
                Builder(
                  builder: (BuildContext scaffoldContext) {
                    return SizedBox(
                      width: 54,
                      height: 48,
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 24,
                                  height: 3,
                                  color: color_white,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                Container(
                                  width: 24,
                                  height: 3,
                                  color: color_white,
                                  margin: const EdgeInsets.only(bottom: 4),
                                ),
                                Container(
                                  width: 24,
                                  height: 3,
                                  color: color_white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Title (Centered)
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: weight.medium,
                        color: color_white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

                /*

                // Notification Bell
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Material(
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
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),

                */

                // Transparent spacer to balance the hamburger menu
                const SizedBox(
                  width: 54,
                  height: 48,
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
