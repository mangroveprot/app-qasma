import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../helpers/helpers.dart';

import '../../../infrastructure/routes/app_routes.dart';
import '../../../theme/theme_extensions.dart';
import '../../utils/constant.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      Navigator.pop(context);
    } else {
      context.go(Routes.root);
    }
  }

  void _goHome(BuildContext context) {
    context.go(Routes.home_path);
  }

  Future<void> _contactSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: guidance_email,
      queryParameters: {
        'subject': 'JRMSU-KC Gcare Support Request',
      },
    );

    await launchExternalUrl(uri: emailUri);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Icon(
                Icons.error_outline,
                size: 96,
                color: colors.textPrimary,
              ),
              const SizedBox(height: 32),

              // 404 Text
              Text(
                '404',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Error Message
              Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colors.black,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textPrimary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _goBack(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _goHome(context),
                      icon: const Icon(Icons.home),
                      label: const Text('Go Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.secondary,
                        foregroundColor: colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Contact Support
              TextButton(
                onPressed: _contactSupport,
                child: Text(
                  'Need help? Contact support',
                  style: TextStyle(
                    color: colors.secondary,
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
