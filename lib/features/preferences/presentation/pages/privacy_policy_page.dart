import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Privacy Policy',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrivacyPolicyContent(),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last updated: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 24),

        // Introduction
        _buildSection(
          context,
          'Introduction',
          'This Privacy Policy describes how [Your App Name] ("we", "our", or "us") collects, uses, and protects your information when you use our mobile application.',
        ),

        // Information We Collect
        _buildSection(
          context,
          'Information We Collect',
          'We may collect the following types of information:\n\n'
              '• Personal Information: Name, email address, and other information you provide\n'
              '• Device Information: Device type, operating system, and app version\n'
              '• Usage Data: How you interact with our app\n'
              '• Location Data: With your permission, we may collect location information',
        ),

        // How We Use Information
        _buildSection(
          context,
          'How We Use Your Information',
          'We use the collected information to:\n\n'
              '• Provide and maintain our service\n'
              '• Improve user experience\n'
              '• Send you updates and notifications\n'
              '• Analyze usage patterns\n'
              '• Comply with legal obligations',
        ),

        // Data Sharing
        _buildSection(
          context,
          'Data Sharing and Disclosure',
          'We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:\n\n'
              '• With your explicit consent\n'
              '• To comply with legal requirements\n'
              '• To protect our rights and safety\n'
              '• With trusted service providers who assist us',
        ),

        // Data Security
        _buildSection(
          context,
          'Data Security',
          'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
        ),

        // Your Rights
        _buildSection(
          context,
          'Your Rights',
          'You have the right to:\n\n'
              '• Access your personal data\n'
              '• Correct inaccurate information\n'
              '• Request deletion of your data\n'
              '• Opt-out of certain communications\n'
              '• Withdraw consent where applicable',
        ),

        // Third-Party Services
        _buildSection(
          context,
          'Third-Party Services',
          'Our app may contain links to third-party services. We are not responsible for the privacy practices of these external services. Please review their privacy policies separately.',
        ),

        // Children's Privacy
        _buildSection(
          context,
          'Children\'s Privacy',
          'Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13. If you become aware that a child has provided us with personal information, please contact us.',
        ),

        // Changes to Policy
        _buildSection(
          context,
          'Changes to This Privacy Policy',
          'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
        ),

        // Contact Information
        _buildContactSection(context),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'If you have any questions about this Privacy Policy, please contact us:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _launchEmail(context, 'privacy@yourapp.com'),
            child: Text(
              'Email: privacy@yourapp.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Address: [Your Company Address]',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Privacy Policy Inquiry',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showNoEmailClientDialog(context, email);
      }
    } catch (e) {
      debugPrint('Could not launch email: $e');
      _showEmailError(context, email);
    }
  }

  void _showNoEmailClientDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Email Client Found'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('No email client is installed on this device.'),
              const SizedBox(height: 12),
              const Text('You can contact us at:'),
              const SizedBox(height: 8),
              SelectableText(
                email,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEmailError(BuildContext context, String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unable to open email client. Contact us at: $email'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'COPY',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: email));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email copied to clipboard'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
