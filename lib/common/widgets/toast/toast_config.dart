import 'package:flutter/material.dart';
import '../../../theme/theme_extensions.dart';
import 'toast_enums.dart';

class ToastConfig {
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;

  const ToastConfig({
    this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  static ToastConfig getToastConfig(
    BuildContext context,
    ToastType? type,
    IconData? customIcon,
  ) {
    final _textColor = context.colors.white;
    switch (type) {
      case ToastType.info:
        return ToastConfig(
          icon: customIcon ?? Icons.info_outline,
          backgroundColor: context.colors.secondary,
          textColor: _textColor,
        );
      case ToastType.warning:
        return ToastConfig(
          icon: customIcon ?? Icons.warning_amber_outlined,
          backgroundColor: context.colors.warning,
          textColor: _textColor,
        );
      case ToastType.success:
        return ToastConfig(
          icon: customIcon ?? Icons.check_circle_outline,
          backgroundColor: context.colors.primary,
          textColor: _textColor,
        );
      case ToastType.error:
        return ToastConfig(
          icon: customIcon ?? Icons.error_outline,
          backgroundColor: context.colors.error,
          textColor: _textColor,
        );
      default:
        return ToastConfig(
          icon: customIcon,
          backgroundColor: const Color(0xFF424242),
          textColor: _textColor,
        );
    }
  }
}
