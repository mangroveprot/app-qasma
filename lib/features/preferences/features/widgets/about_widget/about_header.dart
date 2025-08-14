// widgets/about_header.dart
import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';

class AboutHeader extends StatelessWidget {
  const AboutHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AppIcon(),
        const SizedBox(height: 16),
        const _Title(),
        const SizedBox(height: 12),
        const _Description(),
      ],
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.white, colors.white.withOpacity(0.8)],
        ),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.webp',
          fit: BoxFit.cover,
          cacheWidth: 104,
          cacheHeight: 104,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    return Text(
      'About QASMA',
      style: TextStyle(
        fontSize: 28,
        fontWeight: fontWeight.bold,
        color: colors.black,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'QRCode-Enable Appointment And Scheduling Management Application for the Guidance Office at Jose Rizal Memorial State University - Katipunan Campus.',
        style: TextStyle(
          fontSize: 14,
          color: colors.textPrimary,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
