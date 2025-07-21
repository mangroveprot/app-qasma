import 'package:flutter/material.dart';
import 'toast_enums.dart';

class ToastItem {
  final String message;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;
  final ToastPosition position;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showCloseButton;

  const ToastItem({
    required this.message,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.duration,
    required this.position,
    this.actionLabel,
    this.onAction,
    required this.showCloseButton,
  });
}
