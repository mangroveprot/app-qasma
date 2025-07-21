import 'package:flutter/material.dart';
import 'toast_enums.dart';
import 'toast_config.dart';
import 'toast_item.dart';
import 'toast_container.dart';

class CustomToast {
  CustomToast._();

  static OverlayEntry? _overlayEntry;
  static final GlobalKey<ToastContainerState> _containerKey = GlobalKey();

  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.bottomRight,
    ToastType? type,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseButton = true,
  }) {
    final config = ToastConfig.getToastConfig(context, type, icon);

    if (_overlayEntry == null) {
      _createOverlay(context);
    }

    _containerKey.currentState?.addToast(
      ToastItem(
        message: message,
        icon: config.icon,
        backgroundColor: config.backgroundColor,
        textColor: config.textColor,
        duration: duration,
        position: position,
        actionLabel: actionLabel,
        onAction: onAction,
        showCloseButton: showCloseButton,
      ),
    );
  }

  static void _createOverlay(BuildContext context) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final container = ToastContainer(key: _containerKey);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _containerKey.currentState?.setOnAllToastsEmpty(_removeOverlay);
        });
        return container;
      },
    );

    overlay.insert(_overlayEntry!);
  }

  static void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // methods
  static void info({
    required BuildContext context,
    required String message,
    ToastPosition position = ToastPosition.bottomRight,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseButton = true,
  }) => show(
    context,
    message: message,
    type: ToastType.info,
    position: position,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
    showCloseButton: showCloseButton,
  );

  static void success({
    required BuildContext context,
    required String message,
    ToastPosition position = ToastPosition.bottomRight,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseButton = true,
  }) => show(
    context,
    message: message,
    type: ToastType.success,
    position: position,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
    showCloseButton: showCloseButton,
  );

  static void warning({
    required BuildContext context,
    required String message,
    ToastPosition position = ToastPosition.bottomRight,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseButton = true,
  }) => show(
    context,
    message: message,
    type: ToastType.warning,
    position: position,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
    showCloseButton: showCloseButton,
  );

  static void error({
    required BuildContext context,
    required String message,
    ToastPosition position = ToastPosition.bottomRight,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseButton = true,
  }) => show(
    context,
    message: message,
    type: ToastType.error,
    position: position,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
    showCloseButton: showCloseButton,
  );
}
