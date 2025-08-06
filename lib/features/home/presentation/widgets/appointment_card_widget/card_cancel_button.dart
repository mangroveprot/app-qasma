import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../common/widgets/button_text/custom_text_button.dart';
import '../../../../../theme/theme_extensions.dart';

class CardCancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CardCancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = context.weight;
    final radii = context.radii;
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Builder(builder: (context) {
        return Align(
          alignment: Alignment.centerRight,
          child: IntrinsicWidth(
            child: CustomTextButton(
              height: 44,
              text: 'Cancel',
              fontSize: 12,
              textColor: colors.white,
              backgroundColor: colors.error,
              textDecoration: TextDecoration.none,
              fontWeight: weight.medium,
              borderRadius: radii.medium,
              iconData: Icons.cancel,
              iconPosition: Position.left,
              iconSize: 12,
              onPressed: () async {
                final cubit = context.read<ButtonCubit>();
                cubit.emitLoading();
                await Future.delayed(const Duration(milliseconds: 500));
                onPressed();
                cubit.emitInitial();
              },
            ),
          ),
        );
      }),
    );
  }
}
