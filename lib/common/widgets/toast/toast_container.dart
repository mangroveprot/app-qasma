import 'dart:async';
import 'package:flutter/material.dart';
import 'toast_enums.dart';
import 'toast_item.dart';
import 'animated_toast.dart';

class ToastContainer extends StatefulWidget {
  const ToastContainer({super.key});

  @override
  State<ToastContainer> createState() => ToastContainerState();
}

class ToastContainerState extends State<ToastContainer> {
  final MAX = 4; // max toast to show

  final Map<ToastPosition, List<ToastItem>> _toastsByPosition = {
    ToastPosition.topRight: [],
    ToastPosition.topCenter: [],
    ToastPosition.bottomRight: [],
    ToastPosition.center: [],
    ToastPosition.bottomCenter: [],
  };

  final Set<Timer> _activeTimers = <Timer>{};

  @override
  void dispose() {
    // cancel all active timers to prevent setState after dispose
    for (final timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();
    super.dispose();
  }

  void addToast(ToastItem toast) {
    print('Adding toast with id: ${toast.id}');
    if (!mounted) return;

    setState(() {
      final toasts = _toastsByPosition[toast.position]!;

      // Limit to 4 toasts per position, remove oldest if exceeding
      while (toasts.length >= MAX) {
        toasts.removeAt(0);
      }

      if (toast.id != null) {
        toasts.removeWhere((t) => t.id == toast.id);
      }

      toasts.add(toast);
    });

    // Create timer and track it
    Timer? timer;
    timer = Timer(toast.duration, () {
      _activeTimers.remove(timer); // Remove from tracking
      _removeToast(toast);
    });
    _activeTimers.add(timer);
  }

  void _removeToast(ToastItem toast) {
    if (!mounted) return; // Check if widget is still mounted

    setState(() {
      _toastsByPosition[toast.position]?.remove(toast);
    });

    // Check if all positions are empty - this will be used by CustomToast
    final bool isEmpty = _toastsByPosition.values.every((list) => list.isEmpty);
    if (isEmpty) {
      Timer? overlayTimer;
      overlayTimer = Timer(const Duration(milliseconds: 300), () {
        _activeTimers.remove(overlayTimer); // Remove from tracking
        if (mounted) {
          // The CustomToast class will handle overlay removal
          _onAllToastsEmpty?.call();
        }
      });
      _activeTimers.add(overlayTimer);
    }
  }

  // callback for when all toasts are removed
  VoidCallback? _onAllToastsEmpty;
  void setOnAllToastsEmpty(VoidCallback callback) {
    _onAllToastsEmpty = callback;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: SafeArea(
          child: Stack(
            children: [
              // top Center
              if (_toastsByPosition[ToastPosition.topCenter]!.isNotEmpty)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: _buildToastColumn(
                    _toastsByPosition[ToastPosition.topCenter]!,
                  ),
                ),

              // top Right
              if (_toastsByPosition[ToastPosition.topRight]!.isNotEmpty)
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildToastColumn(
                    _toastsByPosition[ToastPosition.topRight]!,
                  ),
                ),

              // center
              if (_toastsByPosition[ToastPosition.center]!.isNotEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: _buildToastColumn(
                      _toastsByPosition[ToastPosition.center]!,
                    ),
                  ),
                ),

              // bottom Center
              if (_toastsByPosition[ToastPosition.bottomCenter]!.isNotEmpty)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: _buildToastColumn(
                    _toastsByPosition[ToastPosition.bottomCenter]!,
                  ),
                ),

              // bottom Right
              if (_toastsByPosition[ToastPosition.bottomRight]!.isNotEmpty)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _buildToastColumn(
                    _toastsByPosition[ToastPosition.bottomRight]!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToastColumn(List<ToastItem> toasts) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end, // align to right all toast
      children: toasts
          .map(
            (toast) => AnimatedToast(
              key: ValueKey(toast.hashCode),
              toast: toast,
              onDismiss: () => _removeToast(toast),
            ),
          )
          .toList(),
    );
  }
}
