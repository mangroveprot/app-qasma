import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../theme/theme_extensions.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 24.0, bottom: 16.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                context.push(Routes.buildPath(
                    Routes.preference_path, Routes.helpAndSupport));
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: context.colors.textPrimary,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
