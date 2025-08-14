import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/custom_app_bar.dart';

class TermsAndConditionPage extends StatelessWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Terms And Conditions',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TermsConditionsContent(),
          ],
        ),
      ),
    );
  }
}

class TermsConditionsContent extends StatelessWidget {
  const TermsConditionsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Terms and Conditions',
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
          'Welcome to [Your App Name]. These Terms and Conditions ("Terms") govern your use of our mobile application operated by [Your Company Name] ("we", "us", or "our").\n\nBy downloading, installing, or using our app, you agree to be bound by these Terms. If you do not agree with any part of these Terms, you may not use our app.',
        ),

        // Acceptance of Terms
        _buildSection(
          context,
          'Acceptance of Terms',
          'By accessing and using this app, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
        ),

        // License to Use
        _buildSection(
          context,
          'License to Use App',
          'We grant you a revocable, non-exclusive, non-transferable, limited license to download, install, and use the app solely for your personal, non-commercial purposes strictly in accordance with the terms of this license.\n\nYou may not:\n'
              '• Modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell any content or software obtained from the app\n'
              '• Reverse engineer, disassemble, or decompile the app\n'
              '• Remove any copyright or other proprietary notations from the app\n'
              '• Use the app for any commercial purpose or for the benefit of any third party',
        ),

        // User Accounts
        _buildSection(
          context,
          'User Accounts',
          'When you create an account with us, you must provide information that is accurate, complete, and current at all times. You are responsible for safeguarding the password and for all activities that occur under your account.\n\nYou agree not to disclose your password to any third party and to take sole responsibility for activities and actions under your password, whether or not you have authorized such activities or actions.',
        ),

        // Prohibited Uses
        _buildSection(
          context,
          'Prohibited Uses',
          'You may not use our app:\n\n'
              '• For any unlawful purpose or to solicit others to perform unlawful acts\n'
              '• To violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances\n'
              '• To infringe upon or violate our intellectual property rights or the intellectual property rights of others\n'
              '• To harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate\n'
              '• To submit false or misleading information\n'
              '• To upload or transmit viruses or any other type of malicious code\n'
              '• To spam, phish, pharm, pretext, spider, crawl, or scrape\n'
              '• For any obscene or immoral purpose\n'
              '• To interfere with or circumvent the security features of our app',
        ),

        // Content and Intellectual Property
        _buildSection(
          context,
          'Content and Intellectual Property',
          'The app and its original content, features, and functionality are and will remain the exclusive property of [Your Company Name] and its licensors. The app is protected by copyright, trademark, and other laws. Our trademarks may not be used in connection with any product or service without our prior written consent.',
        ),

        // User-Generated Content
        _buildSection(
          context,
          'User-Generated Content',
          'Our app may allow you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material ("Content"). You are responsible for the Content that you post to the app, including its legality, reliability, and appropriateness.\n\nBy posting Content to the app, you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through the app.',
        ),

        // Privacy Policy
        _buildSection(
          context,
          'Privacy Policy',
          'Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the app, to understand our practices.',
        ),

        // Termination
        _buildSection(
          context,
          'Termination',
          'We may terminate or suspend your account and bar access to the app immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever, including but not limited to a breach of the Terms.\n\nIf you wish to terminate your account, you may simply discontinue using the app.',
        ),

        // Disclaimer
        _buildSection(
          context,
          'Disclaimer',
          'The information on this app is provided on an "as is" basis. To the fullest extent permitted by law, this Company:\n\n'
              '• Excludes all representations and warranties relating to this app and its contents\n'
              '• Excludes all liability for damages arising out of or in connection with your use of this app',
        ),

        // Limitation of Liability
        _buildSection(
          context,
          'Limitation of Liability',
          'In no event shall [Your Company Name], nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your use of the app.',
        ),

        // Indemnification
        _buildSection(
          context,
          'Indemnification',
          'You agree to defend, indemnify, and hold harmless [Your Company Name] and its licensee and licensors, and their employees, contractors, agents, officers and directors, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney\'s fees).',
        ),

        // Governing Law
        _buildSection(
          context,
          'Governing Law',
          'These Terms shall be interpreted and governed by the laws of [Your Jurisdiction], without regard to its conflict of law provisions. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights.',
        ),

        // Changes to Terms
        _buildSection(
          context,
          'Changes to Terms',
          'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days notice prior to any new terms taking effect.',
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
            'Contact Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'If you have any questions about these Terms and Conditions, please contact us:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _launchEmail(context, 'legal@yourapp.com'),
            child: Text(
              'Email: legal@yourapp.com',
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
          const SizedBox(height: 8),
          Text(
            'Phone: [Your Phone Number]',
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
      query: 'subject=Terms and Conditions Inquiry',
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
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: email));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy Email'),
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
