import 'package:flutter/material.dart';

import '../../../../../theme/theme_extensions.dart';
import 'login_create_account.dart';

class LoginCreateAccountPrompt extends StatelessWidget {
  const LoginCreateAccountPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textPrimary,
              fontWeight: context.weight.regular,
            ),
          ),
          const SizedBox(width: 4),
          const LoginCreateAccountButton(),
        ],
      ),
    );
  }
}
