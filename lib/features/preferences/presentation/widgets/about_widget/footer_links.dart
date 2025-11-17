import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';
import '../../pages/privacy_policy_page.dart';

class FooterLinks extends StatelessWidget {
  const FooterLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            'Policies & Guidelines',
            style: TextStyle(
              fontSize: 10,
              color: colors.secondary,
            ),
          ),
        ),
        Text('  |  ', style: TextStyle(color: colors.textPrimary)),
        InkWell(
          onTap: () => _openPrivacyPolicy(context),
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

  void _openPrivacyPolicy(BuildContext context) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const PrivacyPolicyContent(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
