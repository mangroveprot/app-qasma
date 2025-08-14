import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';
import 'about_feature_container.dart';
import 'about_section_container.dart';

class MissionSection extends StatelessWidget {
  const MissionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final List<FeatureCardData> _features = [
      FeatureCardData(
        icon: Icons.qr_code,
        color: colors.secondary,
        title: 'QR Code Enabled',
        description: 'Quick access through scanning',
      ),
      FeatureCardData(
        icon: Icons.shield,
        color: colors.primary,
        title: 'Confidential',
        description: 'Privacy and security protected',
      ),
      FeatureCardData(
        icon: Icons.flash_on,
        color: colors.warning,
        title: 'Efficient',
        description: 'Quick booking with confirmations',
      ),
    ];

    return AboutSectionContainer(
      icon: Icons.flash_on,
      title: 'Our Mission',
      description:
          'QASMA combines QR code technology with comprehensive appointment scheduling for JRMSU-KC students and guidance staff.',
      child: Column(
        children: [
          for (int i = 0; i < _features.length; i++) ...[
            FeatureCard(data: _features[i]),
            if (i < _features.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
