import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../theme/theme_extensions.dart';

class LoginCreateAccountButton extends StatelessWidget {
  const LoginCreateAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorToUse = context.colors.textPrimary;
    return Container(
      padding: const EdgeInsets.all(12),
      child: BlocProvider(
        create: (context) => ButtonCubit(),
        child: Builder(builder: (context) {
          return CustomTextButton(
            onPressed: () async {
              final cubit = context.read<ButtonCubit>();
              cubit.emitLoading();
              await Future.delayed(const Duration(milliseconds: 500));
              cubit.emitInitial();
              context
                  .push(Routes.buildPath(Routes.aut_path, Routes.get_started));
            },
            text: 'Create Account',
            border: Border.all(color: colorToUse, width: 1.5),
            borderRadius: BorderRadius.circular(8),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          );
        }),
      ),
    );
  }
}
