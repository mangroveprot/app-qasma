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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(
                color: colors.secondary,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 28,
              color: colors.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.idNumber,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: fontWeight.medium,
                    color: colors.black,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  currentUserId == user.idNumber
                      ? 'Update your personal information'
                      : 'Updated user profile information',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: fontWeight.regular,
                    color: colors.black.withOpacity(0.8),
                    height: 1.4,
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
