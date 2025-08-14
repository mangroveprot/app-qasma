import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';
import 'about_feature_container.dart';
import 'about_section_container.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final List<FeatureCardData> _teamData = [
      FeatureCardData(
        icon: Icons.code,
        color: colors.secondary,
        title: 'Development Team',
        description:
            'Dedicated to creating efficient solutions for the JRMSU-KC community',
      ),
      FeatureCardData(
        icon: Icons.school,
        color: colors.primary,
        title: 'Guidance Office',
        description:
            'Our partners who provided insights and requirements for the system',
      ),
    ];

    return AboutSectionContainer(
      icon: Icons.people,
      title: 'Development Team',
      description:
          'Meet the dedicated team behind QASMA and our partners who made this project possible.',
      child: Column(
        children: [
          for (int i = 0; i < _teamData.length; i++) ...[
            FeatureCard(data: _teamData[i]),
            if (i < _teamData.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
