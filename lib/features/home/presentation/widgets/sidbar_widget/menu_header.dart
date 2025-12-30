import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';
import 'menu_close_button.dart';

class MenuHeader extends StatelessWidget {
  final String user_name;
  final String idNumber;

  const MenuHeader({
    super.key,
    required this.user_name,
    required this.idNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.primary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withOpacity(0.9),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Column(
        children: [
          // Top row with avatar, username, and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.white.withOpacity(0.15),
                  border: Border.all(
                    color: colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              // Username and ID in center
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      user_name,
                      style: TextStyle(
                        color: colors.white,
                        fontSize: 16,
                        fontWeight: weight.medium,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ID : ${idNumber}',
                          style: TextStyle(
                            color: colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: weight.medium,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Close Button
              const MenuCloseButton(),
            ],
          ),
        ],
      ),
    );
  }
}
