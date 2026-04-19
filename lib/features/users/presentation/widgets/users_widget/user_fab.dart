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
    final isStudent = role.toLowerCase() == 'student';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isStudent) ...[
          FloatingActionButton(
            heroTag: 'scan-qr-$role',
            onPressed: () {
              context.push(
                Routes.buildPath(
                  Routes.user_path,
                  Routes.student_qr_scan,
                ),
                extra: {
                  'onSuccess': () async {
                    await onRefresh();
                  },
                },
              );
            },
            backgroundColor: colors.secondary,
            foregroundColor: colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.qr_code_scanner,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Scan QR',
            style: TextStyle(
              fontSize: 12,
              color: colors.textPrimary,
              fontWeight: weight.medium,
            ),
          ),
          const SizedBox(height: 16),
        ],
        FloatingActionButton(
          heroTag: 'add-user-$role',
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
