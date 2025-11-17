import 'package:flutter/material.dart';

import '../../../../theme/theme_extensions.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          InkWell(
            onTap:
                currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.white,
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_left,
                size: 18,
                color: currentPage > 0
                    ? const Color(0xFF374151)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Page indicator
          Text(
            '${currentPage + 1} of $totalPages',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 16),
          // Next button
          InkWell(
            onTap: currentPage < totalPages - 1
                ? () => onPageChanged(currentPage + 1)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.white,
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_right,
                size: 18,
                color: currentPage < totalPages - 1
                    ? const Color(0xFF374151)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
