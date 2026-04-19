import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/helpers/spacing.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class BookCategorySection extends StatelessWidget {
  final String category;
  const BookCategorySection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: radius.large,
            gradient: LinearGradient(
              colors: [
                colors.primary.withOpacity(0.12),
                colors.primary.withOpacity(0.03),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: radius.medium,
                ),
                child: Icon(
                  Icons.event_note_rounded,
                  color: colors.white,
                  size: 22,
                ),
              ),
              Spacing.horizontalMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment category',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.secondary,
                        fontWeight: fontWeight.regular,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      capitalizeWords(category),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.textPrimary,
                        fontWeight: fontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
