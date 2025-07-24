import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../theme/theme_extensions.dart';

class LoginCreateAccountButton extends StatelessWidget {
  const LoginCreateAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: CustomAppButton(
        buttonText: 'Create Account',
        fontWeight: context.weight.medium,
        borderRadius: context.radii.medium,
        disabledBackgroundColor: context.colors.textPrimary,
        mainAxisAlignment: MainAxisAlignment.center,
        border: Border.all(color: context.colors.textPrimary, width: 1.5),
        onPressed: () {
          context.push(Routes.buildPath(Routes.aut_path, Routes.get_started));
        },
      ),
    );
  }
}
