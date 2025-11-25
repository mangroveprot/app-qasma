import 'package:flutter/material.dart';

import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../theme/theme_extensions.dart';

class CreateAccountTermsFooter extends StatelessWidget {
  const CreateAccountTermsFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Future<void> _redirectPrivacy() async {
      final Uri mapsUri = Uri.parse(gcareapp_privacy);

      launchExternalUrl(uri: mapsUri);
    }

    Future<void> _redirectTerms() async {
      final Uri mapsUri = Uri.parse(gcareapp_terms);

      launchExternalUrl(uri: mapsUri);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'By creating an account, you agree to our ',
          style: TextStyle(
            color: colors.textPrimary.withOpacity(0.7),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        GestureDetector(
          onTap: _redirectTerms,
          child: Text(
            'Terms and Conditions',
            style: TextStyle(
              color: colors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
              height: 1.4,
            ),
          ),
        ),
        Text(
          ' and ',
          style: TextStyle(
            color: colors.textPrimary.withOpacity(0.7),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        GestureDetector(
          onTap: _redirectPrivacy,
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              color: colors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
              height: 1.4,
            ),
          ),
        ),
        Text(
          '.',
          style: TextStyle(
            color: colors.textPrimary.withOpacity(0.7),
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
