import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../infrastructure/theme/theme_extensions.dart';
import '../button_text/custom_text_button.dart';

import '../bloc/button/button_cubit.dart';

class InfoModalDialog {
  static Future<void> show({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget content,
    String primaryButtonText = 'Got it',
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    ButtonCubit? buttonCubit,
    String? buttonId,
    double? maxWidth,
    double? maxHeight,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? MediaQuery.of(context).size.width * 0.9,
              maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child:
                            Icon(icon, size: 24, color: context.colors.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: context.weight.bold,
                          color: context.colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.colors.textPrimary,
                          fontWeight: context.weight.regular,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      content,
                      const SizedBox(height: 20),
                      _buildButtons(
                        context,
                        buttonText: primaryButtonText,
                        onButtonPressed: onPrimaryPressed,
                        secondaryButtonText: secondaryButtonText,
                        onSecondaryButtonPressed: onSecondaryPressed,
                        cubit: buttonCubit,
                        buttonId: buttonId,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildButtons(
    BuildContext context, {
    required String buttonText,
    VoidCallback? onButtonPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonPressed,
    ButtonCubit? cubit,
    String? buttonId,
  }) {
    final hasSecondary = secondaryButtonText != null;

    final primaryButton = cubit != null
        ? BlocProvider<ButtonCubit>.value(
            value: cubit,
            child: Builder(builder: (context) {
              return CustomTextButton(
                onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
                text: buttonText,
                textColor: context.colors.white,
                fontSize: 15,
                fontWeight: context.weight.medium,
                backgroundColor: context.colors.primary,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(vertical: 12),
                loadingIndicatorColor: context.colors.white,
                width: double.infinity,
                height: 48,
                buttonId: buttonId,
              );
            }),
          )
        : _buildPrimaryButton(context, buttonText, onButtonPressed);

    if (!hasSecondary) return primaryButton;

    return Column(
      children: [
        primaryButton,
        const SizedBox(height: 10),
        _buildSecondaryButton(
            context, secondaryButtonText, onSecondaryButtonPressed),
      ],
    );
  }

  static Widget _buildPrimaryButton(
    BuildContext context,
    String text,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          foregroundColor: context.colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: context.weight.medium,
            color: context.colors.white,
          ),
        ),
      ),
    );
  }

  static Widget _buildSecondaryButton(
    BuildContext context,
    String text,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: context.colors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: context.weight.medium,
            color: context.colors.textPrimary.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
