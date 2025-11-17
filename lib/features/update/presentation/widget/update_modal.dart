import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/widgets/custom_modal/info_modal_dialog.dart';
import '../../../../theme/theme_extensions.dart';
import '../../data/models/release_info_model.dart';

class UpdateDialog {
  static Future<void> show({
    required BuildContext context,
    required String currentVersion,
    required String currentBuild,
    required ReleaseInfoModel latestRelease,
    required String officialWebsiteUrl,
  }) {
    final isMandatory = latestRelease.isMandatory;

    return InfoModalDialog.show(
      context: context,
      icon: Icons.system_update_rounded,
      title: isMandatory ? 'Update Required' : 'Update Available',
      subtitle: _buildSubtitle(latestRelease, isMandatory),
      content: _buildContent(
        context,
        latestRelease: latestRelease,
        isMandatory: isMandatory,
      ),
      primaryButtonText: 'Update Now',
      onPrimaryPressed: () => _launchWebsite(context, officialWebsiteUrl),
      secondaryButtonText: isMandatory ? null : 'Later',
      onSecondaryPressed:
          isMandatory ? null : () => Navigator.of(context).pop(),
      isDismissible: !isMandatory,
    );
  }

  static Future<void> showNoUpdateAvailable({
    required BuildContext context,
    required String currentVersion,
    required String currentBuild,
  }) {
    return InfoModalDialog.show(
      context: context,
      icon: Icons.check_circle_rounded,
      title: 'You\'re Up to Date',
      subtitle: 'Version $currentVersion-build$currentBuild',
      content: _buildNoUpdateContent(context),
      primaryButtonText: 'Okay',
      onPrimaryPressed: () => Navigator.of(context).pop(),
      isDismissible: true,
    );
  }

  static String _buildSubtitle(
      ReleaseInfoModel latestRelease, bool isMandatory) {
    final versionText =
        'Version ${latestRelease.version}-build${latestRelease.buildNumber}';

    if (latestRelease.size.isNotEmpty) {
      return '$versionText - ${latestRelease.size}';
    }

    return versionText;
  }

  static Widget _buildContent(
    BuildContext context, {
    required ReleaseInfoModel latestRelease,
    required bool isMandatory,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (latestRelease.releaseNotes.isNotEmpty) ...[
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.colors.textPrimary.withOpacity(0.08),
              ),
            ),
            child: SingleChildScrollView(
              child: MarkdownBody(
                data: latestRelease.releaseNotes,
                styleSheet: MarkdownStyleSheet(
                  h3: TextStyle(
                    fontSize: 15,
                    fontWeight: context.weight.bold,
                    color: context.colors.textPrimary,
                    height: 1.4,
                  ),
                  p: TextStyle(
                    fontSize: 13,
                    fontWeight: context.weight.regular,
                    color: context.colors.textPrimary.withOpacity(0.8),
                    height: 1.6,
                  ),
                  listBullet: TextStyle(
                    fontSize: 13,
                    color: context.colors.primary,
                    height: 1.6,
                  ),
                  listIndent: 20,
                  blockSpacing: 16,
                  strong: TextStyle(
                    fontWeight: context.weight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          'Visit our official website to download the latest update.',
          style: TextStyle(
            color: context.colors.textPrimary.withOpacity(0.7),
            fontSize: 14,
            fontWeight: context.weight.regular,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Widget _buildNoUpdateContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your app is running the latest version. No updates are available at this time.',
          style: TextStyle(
            color: context.colors.textPrimary.withOpacity(0.8),
            fontSize: 14,
            fontWeight: context.weight.regular,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Future<void> _launchWebsite(
    BuildContext context,
    String url,
  ) async {
    Navigator.of(context).pop();

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open website: $url'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }
}
