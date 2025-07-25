import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/button/custom_app_button.dart';
import '../../../../../theme/theme_extensions.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Builder(builder: (context) {
        return CustomAppButton(
          labelText: 'Create account',
          labelTextColor: context.colors.white,
          backgroundColor: context.colors.primary,
          labelTextDecoration: TextDecoration.none,
          labelFontWeight: context.weight.medium,
          borderRadius: context.radii.medium,
          disabledBackgroundColor: context.colors.textPrimary,
          contentAlignment: MainAxisAlignment.center,
          onPressedCallback: onPressed,
        );
      }),
    );
  }
}
