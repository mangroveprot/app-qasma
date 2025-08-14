// widgets/contact_section.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../theme/theme_extensions.dart';
import 'about_section_container.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutSectionContainer(
      icon: Icons.contact_support,
      title: 'Contact Us',
      description:
          'Have questions about QASMA or need technical support? We\'re here to help make your experience smooth.',
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
    return _ContactButton(
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
    return _ContactButton(
      icon: Icons.email,
      title: 'Email Support',
      description: 'Get help via email: guidance@jrmsu.edu.ph',
      color: colors.secondary,
      onPressed: _launchEmail,
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: guidance_email,
      queryParameters: {
        'subject': 'QASMA Support Request',
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
    return _ContactButton(
      icon: Icons.location_on,
      title: 'Visit Guidance Office',
      description: 'Find us at JRMSU-KC campus for in-person support',
      color: colors.primary,
      onPressed: _openMaps,
    );
  }

  Future<void> _openMaps() async {
    final Uri mapsUri = Uri.parse('https://maps.app.goo.gl/qywZG2wXxTS6eJov5');

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onPressed;

  const _ContactButton({
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
