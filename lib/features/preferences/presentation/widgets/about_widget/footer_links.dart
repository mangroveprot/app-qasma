import 'package:flutter/material.dart';
import '../../../../../common/helpers/helpers.dart';
import '../../../../../common/utils/constant.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _redirectPrivacy() async {
      final Uri mapsUri = Uri.parse(gcareapp_privacy);

      launchExternalUrl(uri: mapsUri);
    }

    Future<void> _redirectTerms() async {
      final Uri mapsUri = Uri.parse(gcareapp_terms);

      launchExternalUrl(uri: mapsUri);
    }

    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: _redirectTerms,
          child: Text(
            'Terms and Conditions',
            style: TextStyle(
              fontSize: 10,
              color: colors.secondary,
            ),
          ),
        ),
        Text('  |  ', style: TextStyle(color: colors.textPrimary)),
        InkWell(
          onTap: _redirectPrivacy,
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              fontSize: 10,
              color: colors.secondary,
            ),
          ),
        ),
        Text('  |  ', style: TextStyle(color: colors.textPrimary)),
        InkWell(
          onTap: () {},
          child: Text(
            'Credits',
            style: TextStyle(
              fontSize: 10,
              color: colors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
