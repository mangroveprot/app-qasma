import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class AboutSectionContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  const AboutSectionContainer({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: icon, title: title),
          const SizedBox(height: 12),
          _SectionDescription(description: description),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colors.secondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: fontWeight.bold,
              color: colors.black.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionDescription extends StatelessWidget {
  final String description;

  const _SectionDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      description,
      style: TextStyle(
        fontSize: 14,
        color: colors.textPrimary,
        height: 1.4,
      ),
    );
  }
}
