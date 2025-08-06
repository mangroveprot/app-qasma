import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';

class HomeGreetingCard extends StatelessWidget {
  final String userName;

  const HomeGreetingCard({
    super.key,
    this.userName = 'Unknown',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radius = context.radii;
    final color_white = colors.white;
    return Card(
      elevation: 2,
      color: color_white,
      surfaceTintColor: color_white,
      shape: RoundedRectangleBorder(
        borderRadius: radius.medium,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Good ${getTimeOfDayGreeting()} $userName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: weight.bold,
                      color: colors.textPrimary,
                      fontFamily: 'System',
                    ),
                  ),
                  const TextSpan(
                    text: ' 👋',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.horizontalXSmall,
            Text(
              'Hope you\'re having a great day! How can we assist you today?',
              style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
                height: 1.3,
                fontWeight: weight.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
