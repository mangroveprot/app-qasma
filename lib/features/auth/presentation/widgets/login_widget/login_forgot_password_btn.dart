import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';

class LoginForgotPasswordBtn extends StatelessWidget {
  const LoginForgotPasswordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ButtonCubit(),
        child: Builder(builder: (context) {
          return CustomTextButton(
            onPressed: () async {
              final cubit = context.read<ButtonCubit>();
              cubit.emitLoading();
              await Future.delayed(const Duration(milliseconds: 500));
              cubit.emitInitial();
              context.push(
                  Routes.buildPath(Routes.aut_path, Routes.forgot_password));
            },
            text: 'Forgot Password?',
            fontSize: 12,
            width: null,
            fontWeight: context.weight.medium,
            borderRadius: context.radii.medium,
            textDecoration: TextDecoration.none,
          );
        }));
  }
}
