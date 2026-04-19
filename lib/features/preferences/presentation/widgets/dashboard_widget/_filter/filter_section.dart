import 'package:flutter/material.dart';

import '../../../../../../infrastructure/theme/theme_extensions.dart';

class FilterSection extends StatelessWidget {
  final String title;
  final VoidCallback onReset;
  final Widget child;

  const FilterSection({
    Key? key,
    required this.title,
    required this.onReset,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.black,
                  letterSpacing: -0.1,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onReset,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
