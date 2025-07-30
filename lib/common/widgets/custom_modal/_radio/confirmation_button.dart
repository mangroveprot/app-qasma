import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/theme_extensions.dart';
import '../../bloc/button/button_cubit.dart';
import '../../button/custom_app_button.dart';

class ConfirmationButton extends StatelessWidget {
  final String labelText;
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final bool enabled;
  final Color? backgroundColor;

  const ConfirmationButton({
    super.key,
    required this.labelText,
    this.onPressed,
    this.onPressedAsync,
    this.enabled = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;

    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                child: CustomAppButton(
                  onPressedCallback: (!enabled)
                      ? null
                      : () async {
                          final cubit = context.read<ButtonCubit>();
                          cubit.emitLoading();

                          try {
                            if (onPressedAsync != null) {
                              await onPressedAsync!();
                            } else if (onPressed != null) {
                              onPressed!();
                            } else {
                              await Future.delayed(const Duration(seconds: 2));
                            }
                          } catch (e) {
                          } finally {
                            if (context.mounted) {
                              cubit.emitInitial();
                            }
                          }
                        },
                  width: double.infinity,
                  labelText: labelText,
                  backgroundColor: backgroundColor ??
                      (enabled ? colors.primary : colors.textPrimary),
                  borderRadius: radius.large,
                  labelTextColor: colors.white,
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
