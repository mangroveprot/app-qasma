import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../common/widgets/bloc/button/button_cubit.dart';
import '../../../../../theme/theme_extensions.dart';

class LoginFormError extends StatelessWidget {
  const LoginFormError({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final weight = context.weight;

    return BlocBuilder<FormCubit, FormValidationState>(
      builder: (context, formState) {
        return BlocBuilder<ButtonCubit, ButtonState>(
          builder: (context, buttonState) {
            final List<String> allErrors = <String>[];

            for (final entry in formState.errorMessages.entries) {
              if (entry.value != null && entry.value!.isNotEmpty) {
                allErrors.add(entry.value!);
              }
            }

            if (buttonState is ButtonFailureState) {
              allErrors.addAll(buttonState.errorMessages);
            }

            if (allErrors.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.error.withOpacity(0.1),
                  borderRadius: radii.medium,
                  border: Border.all(
                    color: colors.error.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colors.error,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        allErrors.first,
                        style: TextStyle(
                          color: colors.error,
                          fontSize: 12,
                          fontWeight: weight.regular,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
