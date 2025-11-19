import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class ContactButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onPressed;

  const ContactButton({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            _ContactButtonIcon(icon: icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: _ContactButtonContent(
                title: title,
                description: description,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactButtonIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ContactButtonIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 24,
        color: colors.white,
      ),
    );
  }
}

class _ContactButtonContent extends StatelessWidget {
  final String title;
  final String description;

  const _ContactButtonContent({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF4B5563),
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
