import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/theme/theme_extensions.dart';
import '../bloc/button/button_cubit.dart';
import '../button_text/custom_text_button.dart';
import '../modal.dart';
import '../models/modal_option.dart';
import '_radio/animated_radio_content.dart';
import 'animated_selection_content.dart';
import 'single_selection_content.dart';
import 'multi_selection_content.dart';

class CustomModal {
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    Widget? icon,
  }) {
    return Modal.show<bool>(
      context: context,
      child: BlocProvider(
        create: (context) => ButtonCubit(),
        child: Builder(builder: (context) {
          final colors = context.colors;
          final weight = context.weight;
          final radius = context.radii;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ModalUI.header(title),
              const SizedBox(height: 16),
              if (icon != null) ...[
                icon,
                const SizedBox(height: 16),
              ],
              Text(message),
              ModalUI.actions([
                ModalUI.secondaryButton(
                    text: cancelText,
                    onPressed: context.pop,
                    color: cancelButtonColor ?? colors.textPrimary),
                CustomTextButton(
                  onPressed: () async {
                    final cubit = context.read<ButtonCubit>();
                    cubit.emitLoading();
                    await Future.delayed(const Duration(milliseconds: 500));
                    cubit.emitInitial();
                    Navigator.of(context).pop(true);
                  },
                  text: confirmText,
                  textColor: colors.white,
                  fontSize: 14,
                  fontWeight: weight.medium,
                  backgroundColor: colors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  borderRadius: radius.large,
                  width: 100,
                  height: 44,
                )
              ]),
            ],
          );
        }),
      ),
    );
  }

  static Future<T?> simpleShow<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double? maxHeight,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title (centered)
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Content (full width)
            Flexible(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity, // ADD THIS - forces full width
                  child: child,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Future<T?> showCenteredModal<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? icon,
    required List<Widget> actions,
    double? width,
    EdgeInsets? padding,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => ButtonCubit(),
          child: Builder(builder: (context) {
            final colors = context.colors;
            final weight = context.weight;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: colors.white,
              child: Container(
                width: width ?? 320,
                padding: padding ?? const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    if (icon != null) ...[
                      icon,
                      const SizedBox(height: 16),
                    ],

                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: weight.regular,
                        color: colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Subtitle
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: weight.regular,
                          color: colors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Actions
                    Column(
                      children: actions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final action = entry.value;
                        final isLast = index == actions.length - 1;

                        return Column(
                          children: [
                            SizedBox(width: double.infinity, child: action),
                            if (!isLast) const SizedBox(height: 12),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // Helper method to create warning icon with custom color
  static Widget warningIcon({
    Color iconColor = Colors.red,
    Color? backgroundColor,
    double size = 48,
    double iconSize = 24,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.warning,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  // Helper method to create success icon with custom color
  static Widget successIcon({
    Color iconColor = Colors.green,
    Color? backgroundColor,
    double size = 48,
    double iconSize = 24,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  // Helper method to create info icon with custom color
  static Widget infoIcon({
    Color iconColor = Colors.blue,
    Color? backgroundColor,
    double size = 48,
    double iconSize = 24,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.info,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  /// reusable selection modal with custom options
  static Future<String?> showSelectionModal(
    BuildContext context, {
    required List<ModalOption> options,
    String title = 'Select an Option',
    String? subtitle,
    bool isBottomSheet = true,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? maxHeight,
    String backButtonText = 'Back',
    bool showBackButton = true,
  }) {
    return Modal.show<String>(
      context: context,
      isBottomSheet: isBottomSheet,
      backgroundColor: backgroundColor ?? context.colors.white,
      borderRadius:
          borderRadius ?? const BorderRadius.vertical(top: Radius.circular(20)),
      padding: padding ?? EdgeInsets.zero,
      maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
      child: AnimatedSelectionContent(
        options: options,
        title: title,
        subtitle: subtitle,
        backButtonText: backButtonText,
        showBackButton: showBackButton,
      ),
    );
  }

  static Future<T?> showRadioSelectionModal<T>(
    BuildContext context, {
    required List<ModalOption> options,
    String? buttonId,
    SelectedOptionType selectedOptionType = SelectedOptionType.subtitle,
    String title = 'Select an Option',
    String? subtitle,
    bool isBottomSheet = true,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? maxHeight,
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
    String othersPlaceholder = 'Please specify...',
    Future<T> Function(String selectedReason)? onConfirm,
  }) {
    return Modal.show<T>(
      context: context,
      isBottomSheet: isBottomSheet,
      backgroundColor: backgroundColor ?? context.colors.white,
      borderRadius: borderRadius ??
          (isBottomSheet
              ? const BorderRadius.vertical(top: Radius.circular(20))
              : BorderRadius.circular(20)),
      padding: padding ?? EdgeInsets.zero,
      maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
      child: BlocProvider(
        create: (context) => ButtonCubit(),
        child: AnimatedRadioContent<T>(
          buttonId: buttonId,
          selectedOptionType: selectedOptionType,
          options: options,
          title: title,
          subtitle: subtitle,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          othersPlaceholder: othersPlaceholder,
          onConfirm: onConfirm,
        ),
      ),
    );
  }

  /// show single selection modal (radio-style)
  static Future<String?> showSingleSelectionModal(
    BuildContext context, {
    required List<ModalOption> options,
    String title = 'Select an Option',
    String? subtitle,
    String? selectedValue,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return Modal.show<String>(
      context: context,
      child: SingleSelectionContent(
        options: options,
        title: title,
        subtitle: subtitle,
        selectedValue: selectedValue,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  ///  multi-selection modal (checkbox-style)
  static Future<List<String>?> showMultiSelectionModal(
    BuildContext context, {
    required List<ModalOption> options,
    String title = 'Select Options',
    String? subtitle,
    List<String> selectedValues = const [],
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    int? maxSelections,
    int? minSelections,
  }) {
    return Modal.show<List<String>>(
      context: context,
      child: MultiSelectionContent(
        options: options,
        title: title,
        subtitle: subtitle,
        selectedValues: selectedValues,
        confirmText: confirmText,
        cancelText: cancelText,
        maxSelections: maxSelections,
        minSelections: minSelections,
      ),
    );
  }
}
