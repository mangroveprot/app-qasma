import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';

class SocialMediaRow extends StatelessWidget {
  const SocialMediaRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Facebook
        InkWell(
          onTap: () => launchExternalUrl(uri: Uri.parse(guidance_fb_url)),
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFF1877F2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.facebook, color: Colors.white, size: 26),
          ),
        ),
        const SizedBox(width: 16),

        // Email
        InkWell(
          onTap: () => launchExternalUrl(
            uri: Uri.parse('mailto:$guidance_email'),
          ),
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFFEA4335),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.email, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }
}
