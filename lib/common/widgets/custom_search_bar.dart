import 'package:flutter/material.dart';

import '../../infrastructure/theme/theme_extensions.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final double fontSize;
  final double iconSize;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;

  const CustomSearchBar({
    Key? key,
    required this.onSearchChanged,
    this.hintText = 'Search...',
    this.controller,
    this.padding,
    this.fontSize = 14,
    this.iconSize = 22,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onSearchChanged(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radii;
    final shadows = context.shadows;
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: colors.white.withOpacity(0.8),
          borderRadius: radius.medium,
          border: Border.all(color: colors.textPrimary.withOpacity(0.1)),
          boxShadow: [shadows.light]),
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: colors.textPrimary,
            fontSize: widget.fontSize,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colors.textPrimary,
            size: widget.iconSize,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: colors.textPrimary,
                    size: widget.iconSize,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          suffixIconConstraints: _hasText
              ? const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                )
              : null,
          border: InputBorder.none,
          contentPadding: widget.padding ??
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
          isDense: true,
        ),
        style: TextStyle(
          fontSize: widget.fontSize,
          color: colors.black,
        ),
      ),
    );
  }
}
