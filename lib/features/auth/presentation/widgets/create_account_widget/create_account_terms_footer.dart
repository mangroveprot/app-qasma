import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';
import '../../../../preferences/presentation/pages/privacy_policy_page.dart';
import '../../../../preferences/presentation/pages/terms_and_conditions.dart';

class CreateAccountTermsFooter extends StatelessWidget {
  const CreateAccountTermsFooter({Key? key}) : super(key: key);

  void _openTermsAndConditions(BuildContext context) {
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
                color: colors.surface,
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
                      color: colors.textPrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const TermsConditionsContent(),
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

  void _openPrivacyPolicy(BuildContext context) {
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
          onTap: () {
            try {
              _openTermsAndConditions(context);
            } catch (e) {
              debugPrint('Error opening terms: $e');
            }
          },
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
          onTap: () {
            try {
              _openPrivacyPolicy(context);
            } catch (e) {
              debugPrint('Error opening privacy policy: $e');
            }
          },
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
