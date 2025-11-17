import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../infrastructure/routes/app_routes.dart';
import '../../../../../theme/theme_extensions.dart';

class LoginCreateAccountButton extends StatelessWidget {
  const LoginCreateAccountButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Builder(builder: (context) {
        return TextButton(
          onPressed: () async {
            final cubit = context.read<ButtonCubit>();
            cubit.emitLoading();
            await Future.delayed(const Duration(milliseconds: 500));
            cubit.emitInitial();
            context.push(Routes.buildPath(Routes.aut_path, Routes.get_started));
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(4, 12, 8, 12),
            minimumSize: const Size(60, 40),
            tapTargetSize: MaterialTapTargetSize.padded,
            visualDensity: VisualDensity.standard,
          ),
          child: Text(
            'Signup',
            style: TextStyle(
              fontSize: 14,
              fontWeight: context.weight.medium,
              color: context.colors.secondary,
              decoration: TextDecoration.none,
            ),
          ),
        );
      }),
    );
  }
}
