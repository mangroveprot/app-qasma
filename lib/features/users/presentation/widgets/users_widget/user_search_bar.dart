import 'package:flutter/material.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../../../common/widgets/custom_search_bar.dart';

class UsersSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;
  final bool hasActiveFilter;

  const UsersSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onFilterPressed,
    required this.hasActiveFilter,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              onSearchChanged: onSearchChanged,
              hintText: 'Search students...',
              margin: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 10),
          _FilterButton(
            onTap: onFilterPressed,
            hasActiveFilter: hasActiveFilter,
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasActiveFilter;

  const _FilterButton({required this.onTap, required this.hasActiveFilter});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: context.radii.medium,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: colors.white.withOpacity(0.8),
              borderRadius: context.radii.medium,
              border: Border.all(color: colors.textPrimary.withOpacity(0.1)),
              boxShadow: [context.shadows.light],
            ),
            child:
                Icon(Icons.tune_rounded, size: 22, color: colors.textPrimary),
          ),
        ),
        if (hasActiveFilter)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
