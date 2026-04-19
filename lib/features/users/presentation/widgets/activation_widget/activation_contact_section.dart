import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../theme/theme_extensions.dart';

class ActivationContactSection extends StatelessWidget {
  const ActivationContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Future<void> _redirectEmail() async {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: guidance_email,
        queryParameters: {
          'subject': 'JRMSU-KC Gcare Support Request',
        },
      );

      await launchExternalUrl(uri: emailUri);
    }

    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF6B7280),
            height: 1.3,
          ),
          children: [
            const TextSpan(text: 'Questions? Contact the Guidance Office at '),
            TextSpan(
              text: '${guidance_email}',
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _redirectEmail();
                },
            ),
          ],
        ),
      ),
    );
  }
}
