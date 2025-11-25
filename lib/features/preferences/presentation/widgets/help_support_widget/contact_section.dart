import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../theme/theme_extensions.dart';
import 'about_section_container.dart';
import 'contact_button.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutSectionContainer(
      icon: Icons.contact_support,
      title: 'Contact Us',
      description:
          'Have questions about GCare app or need technical support? We\'re here to help make your experience smooth.',
      child: Column(
        children: [
          const _EmailContactButton(),
          const SizedBox(height: 12),
          const _LocationContactButton(),
          const SizedBox(height: 12),
          const _WebsiteContactButton(),
        ],
      ),
    );
  }
}

class _WebsiteContactButton extends StatelessWidget {
  const _WebsiteContactButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ContactButton(
      icon: Icons.language,
      title: 'Visit Official Website',
      description: 'Browse katipunan.jrmsu.edu.ph for university info',
      color: colors.warning.withOpacity(0.6),
      onPressed: _launchWebsite,
    );
  }

  Future<void> _launchWebsite() async {
    final Uri websiteUri = Uri.parse('http://katipunan.jrmsu.edu.ph/');

    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
    }
  }
}

class _EmailContactButton extends StatelessWidget {
  const _EmailContactButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ContactButton(
      icon: Icons.email,
      title: 'Email Support',
      description: 'Get help via email: $guidance_email',
      color: colors.secondary,
      onPressed: _launchEmail,
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: guidance_email,
      queryParameters: {
        'subject': 'Gcare Support Request',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}

class _LocationContactButton extends StatelessWidget {
  const _LocationContactButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ContactButton(
      icon: Icons.location_on,
      title: 'Visit Guidance Office',
      description: 'Find us at JRMSU-KC campus for in-person support',
      color: colors.primary,
      onPressed: _openMaps,
    );
  }

  Future<void> _openMaps() async {
    final Uri mapsUri = Uri.parse(jrmsu_guidance_map);

    launchExternalUrl(uri: mapsUri);
  }
}
