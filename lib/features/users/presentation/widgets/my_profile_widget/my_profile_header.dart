import 'package:flutter/material.dart';

import '../../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = SharedPrefs().getString('currentUserId');
    final colors = context.colors;
    final fontWeight = context.weight;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.secondary.withOpacity(0.8),
            colors.secondary.withOpacity(0.4)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colors.white.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: 24,
              color: colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: fontWeight.bold,
                    color: colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUserId == user.idNumber
                      ? 'Update your personal information'
                      : 'Updated user profile information',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
