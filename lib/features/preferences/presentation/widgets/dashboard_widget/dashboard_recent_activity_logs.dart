import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../activity_logs/data/models/activity_log_model.dart';
import '../../../../activity_logs/domain/entities/activity_log.dart';
import '../../../../activity_logs/presentation/config/activity_logs_config.dart';
import '../../../../activity_logs/presentation/utils/activity_logs_util.dart';
import '../../../../users/data/models/user_model.dart';

class DashboardRecentActivityLogs extends StatelessWidget {
  final List<ActivityLogModel> logs;
  final bool isLoading;
  final List<UserModel> users;

  const DashboardRecentActivityLogs({
    super.key,
    required this.logs,
    this.isLoading = false,
    this.users = const [],
  });

  UserModel? _findUserById(String? userId) {
    if (userId == null || userId.isEmpty || users.isEmpty) return null;
    try {
      return users.firstWhere((u) => u.idNumber == userId);
    } catch (_) {
      return null;
    }
  }

  String _formatRoleWithId(ActivityLogModel log) {
    if (log.userId == null || log.userId!.isEmpty) return 'By: System';

    final user = _findUserById(log.userId);
    final rawRole = user?.role ?? '';
    String roleLabel;

    switch (rawRole.toLowerCase()) {
      case 'staff':
        roleLabel = 'Staff';
        break;
      case 'counselor':
        roleLabel = 'Counselor';
        break;
      case 'student':
        roleLabel = 'Student';
        break;
      default:
        roleLabel = rawRole.isEmpty
            ? 'User'
            : '${rawRole[0].toUpperCase()}${rawRole.substring(1).toLowerCase()}';
    }

    return 'By: $roleLabel • ${log.userId}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;

    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: radius.large,
        boxShadow: [
          BoxShadow(
            color: colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Recent Activity Logs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: fontWeight.bold,
                      color: colors.black.withOpacity(0.8),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push(
                      Routes.buildPath(
                        Routes.preference_path,
                        Routes.activityLogs,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: colors.secondary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: fontWeight.medium,
                    ),
                  ),
                  child: const Text('See more'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: logs.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: isLoading
                        ? Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: colors.primary,
                              ),
                            ),
                          )
                        : Text(
                            'No recent activity yet.',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textPrimary,
                              fontWeight: fontWeight.medium,
                            ),
                          ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: logs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final log = entry.value;
                      final isLast = index == logs.length - 1;
                      // Be defensive: fall back to "system" meta if category is missing.
                      final meta = activityCategoryMeta[log.category] ??
                          activityCategoryMeta[ActivityCategory.system]!;

                      return Container(
                        margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: meta.iconBg,
                                borderRadius: radius.medium,
                              ),
                              child: Icon(
                                meta.icon,
                                color: meta.iconColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          log.action,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: fontWeight.medium,
                                            color:
                                                colors.black.withOpacity(0.8),
                                            letterSpacing: -0.2,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        formatRelativeTime(log.createdAt),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: colors.textPrimary,
                                          fontWeight: fontWeight.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    meta.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colors.textPrimary,
                                      fontWeight: fontWeight.medium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatRoleWithId(log),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          colors.textPrimary.withOpacity(0.8),
                                      fontWeight: fontWeight.regular,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formatFullTime(log.createdAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          colors.textPrimary.withOpacity(0.8),
                                      fontWeight: fontWeight.regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
