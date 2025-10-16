import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class UserFab extends StatelessWidget {
  final String role;
  final Future<void> Function() onRefresh;

  const UserFab({
    super.key,
    required this.role,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            context.push(
              Routes.buildPath(
                Routes.user_path,
                Routes.create_user,
              ),
              extra: {
                'role': role,
                'onSuccess': () async {
                  await onRefresh();
                },
              },
            );
          },
          backgroundColor: colors.primary,
          foregroundColor: colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'New ${role.capitalize()}',
          style: TextStyle(
            fontSize: 12,
            color: colors.textPrimary,
            fontWeight: weight.medium,
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
