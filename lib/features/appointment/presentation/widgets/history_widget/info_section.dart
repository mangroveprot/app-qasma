import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final Map<String, String> items;

  const InfoSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: weight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...items.entries.map((entry) => Padding(
                padding: const EdgeInsets.all(4),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${entry.key}: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: weight.medium,
                          color: colors.black,
                        ),
                      ),
                      TextSpan(
                        text: entry.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
