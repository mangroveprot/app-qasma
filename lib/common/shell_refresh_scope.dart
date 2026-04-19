import 'package:flutter/material.dart';

class ShellRefreshScope extends StatefulWidget {
  final Widget child;

  const ShellRefreshScope({
    super.key,
    required this.child,
  });

  static _ShellRefreshScopeState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ShellRefreshScopeState>();
  }

  @override
  State<ShellRefreshScope> createState() => _ShellRefreshScopeState();
}

class _ShellRefreshScopeState extends State<ShellRefreshScope> {
  final Map<String, VoidCallback> _refreshCallbacks = {};

  void registerRefresh(String route, VoidCallback callback) {
    _refreshCallbacks[route] = callback;
  }

  void refreshCurrent(String route) {
    final callback = _refreshCallbacks[route];
    if (callback != null) {
      callback();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
