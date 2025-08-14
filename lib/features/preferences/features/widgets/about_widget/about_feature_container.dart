// widgets/feature_card.dart
import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class FeatureCardData {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const FeatureCardData({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
}

class FeatureCard extends StatelessWidget {
  final FeatureCardData data;

  const FeatureCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: data.color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          _FeatureIcon(icon: data.icon, color: data.color),
          const SizedBox(width: 12),
          Expanded(
            child: _FeatureContent(
              title: data.title,
              description: data.description,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _FeatureIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }
}

class _FeatureContent extends StatelessWidget {
  final String title;
  final String description;

  const _FeatureContent({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: fontWeight.bold,
            color: colors.black.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: colors.textPrimary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
