import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

enum ToastType { success, error, warning, cancel, original }

enum ToastPosition { top, center, bottom }

class AppToast {
  static void show({
    required String message,
    required ToastType type,
    ToastPosition position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
  }) {
    BotToast.showCustomText(
      duration: duration,
      toastBuilder: (_) => _buildToast(message, type),
      align: _getAlignment(position),
    );
  }

  static void showCustom({
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSize,
    ToastPosition position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    BotToast.showCustomText(
      duration: duration,
      toastBuilder: (_) => _buildCustomToast(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        iconColor: iconColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        iconSize: iconSize,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      align: _getAlignment(position),
    );
  }

  static Widget _buildCustomToast({
    required String message,
    IconData? icon,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSize,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black87,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: iconSize ?? 16,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 13,
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildToast(String message, ToastType type) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getColor(type),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(type),
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Alignment _getAlignment(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.center:
        return Alignment.center;
      case ToastPosition.bottom:
        return const Alignment(0, 0.8); // Like Google's position in image
    }
  }

  static Color _getColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.cancel:
        return Colors.grey;
      case ToastType.original:
        return const Color(0xFF333333);
    }
  }

  static IconData _getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.cancel:
        return Icons.cancel;
      case ToastType.original:
        return Icons.info_outline;
    }
  }
}
