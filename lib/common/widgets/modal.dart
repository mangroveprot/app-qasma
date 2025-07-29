import 'package:flutter/material.dart';

import 'models/modal_option.dart';

class Modal {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isBottomSheet = false,

    // Essential styling
    Color? backgroundColor,
    Color? barrierColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,

    // Behavior
    bool barrierDismissible = true,
    bool useSafeArea = true,

    // Constraints
    double? maxWidth,
    double? maxHeight,
  }) {
    if (isBottomSheet) {
      return _showBottomSheet<T>(
        context: context,
        child: child,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        borderRadius: borderRadius,
        padding: padding,
        useSafeArea: useSafeArea,
      );
    }

    return _showDialog<T>(
      context: context,
      child: child,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      borderRadius: borderRadius,
      padding: padding,
      barrierDismissible: barrierDismissible,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  static Future<T?> _showDialog<T>({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    Color? barrierColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    bool barrierDismissible = true,
    double? maxWidth,
    double? maxHeight,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? 400,
            maxHeight: maxHeight ?? double.infinity,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }

  static Future<T?> _showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    Color? barrierColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor ?? Colors.transparent,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}

/// Simplified modal components
class ModalUI {
  /// Header with title and optional close button
  static Widget header(
    String title, {
    String? subtitle,
    VoidCallback? onClose,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (onClose != null)
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  /// List of options with selection
  static Widget optionsList(
    List<ModalOption> options, {
    String? selected,
    ValueChanged<String>? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < options.length; i++) ...[
          _OptionTile(
            option: options[i],
            isSelected: selected == options[i].value,
            onTap: () => onTap?.call(options[i].value),
          ),
          if (i < options.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  /// Action buttons
  static Widget actions(List<Widget> buttons) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < buttons.length; i++) ...[
            buttons[i],
            if (i < buttons.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }

  /// Primary button
  static Widget primaryButton({
    required text,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style:
          color != null ? FilledButton.styleFrom(backgroundColor: color) : null,
      child: Text(text),
    );
  }

  /// Secondary button
  static Widget secondaryButton({
    required String text,
    Color? color,
    Color? backgroundColor,
    required VoidCallback onPressed,
    double? fontSize,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: fontSize),
        ),
      ),
    );
  }
}

/// Performance-optimized option tile
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.isSelected,
    this.onTap,
  });

  final ModalOption option;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Theme.of(context).primaryColor)
                : null,
          ),
          child: Row(
            children: [
              if (option.icon != null) ...[
                option.icon!,
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            isSelected ? Theme.of(context).primaryColor : null,
                      ),
                    ),
                    if (option.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
