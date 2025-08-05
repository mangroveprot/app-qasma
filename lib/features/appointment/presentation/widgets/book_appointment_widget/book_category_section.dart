import 'package:flutter/material.dart';

import '../../../../../common/helpers/spacing.dart';
import '../../../../../theme/theme_extensions.dart';

class BookCategorySection extends StatelessWidget {
  final String category;
  const BookCategorySection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final fontWeight = context.weight;

    final _sectionTitleStyle = TextStyle(
      fontSize: 14,
      fontWeight: fontWeight.bold,
      color: colors.black,
    );

    final _categoryContainerDecoration = BoxDecoration(
      color: colors.surface,
      borderRadius: radius.large,
    );

    final _categoryTextStyle = TextStyle(
      fontSize: 12,
      color: colors.black,
      fontWeight: fontWeight.regular,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appointment Category', style: _sectionTitleStyle),
        Spacing.verticalMedium,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: _categoryContainerDecoration,
          child: Center(
            child: Text(category, style: _categoryTextStyle),
          ),
        ),
      ],
    );
  }
}
