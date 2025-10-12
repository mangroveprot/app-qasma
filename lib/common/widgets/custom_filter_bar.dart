import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

class CustomDropdownFilter<T> extends StatefulWidget {
  final List<FilterOption<T>> options;
  final Function(T) onFilterChanged;
  final T initialSelection;
  final EdgeInsetsGeometry? padding;
  final Color? selectedColor;
  final Color? backgroundColor;
  final double fontSize;
  final FontWeight? fontWeight;
  final IconData? dropdownIcon;
  final double iconSize;
  final BorderRadius? borderRadius;
  final Border? border;

  const CustomDropdownFilter({
    Key? key,
    required this.options,
    required this.onFilterChanged,
    required this.initialSelection,
    this.padding,
    this.selectedColor,
    this.backgroundColor,
    this.fontSize = 14,
    this.fontWeight,
    this.dropdownIcon,
    this.iconSize = 18,
    this.borderRadius,
    this.border,
  }) : super(key: key);

  @override
  State<CustomDropdownFilter<T>> createState() =>
      _CustomDropdownFilterState<T>();
}

class _CustomDropdownFilterState<T> extends State<CustomDropdownFilter<T>> {
  late T _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialSelection;
  }

  @override
  void didUpdateWidget(CustomDropdownFilter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelection != widget.initialSelection) {
      _selectedOption = widget.initialSelection;
    }
  }

  void _onOptionChanged(T option) {
    if (option != _selectedOption) {
      setState(() {
        _selectedOption = option;
      });
      widget.onFilterChanged(option);
    }
  }

  String _getSelectedLabel() {
    return widget.options
        .firstWhere((option) => option.value == _selectedOption)
        .label;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radius = context.radii;
    return Container(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<T>(
            initialValue: _selectedOption,
            onSelected: _onOptionChanged,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                //  color: widget.backgroundColor ?? Colors.grey[100],
                borderRadius: widget.borderRadius ?? radius.small,
                border: widget.border,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getSelectedLabel(),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: widget.fontWeight ?? fontWeight.medium,
                      color: widget.selectedColor ?? colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    widget.dropdownIcon ?? Icons.filter_list_outlined,
                    size: widget.iconSize,
                    color: widget.selectedColor ?? colors.textPrimary,
                  ),
                ],
              ),
            ),
            itemBuilder: (BuildContext context) {
              return widget.options.map((FilterOption<T> option) {
                final isSelected = option.value == _selectedOption;
                return PopupMenuItem<T>(
                  value: option.value,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: widget.fontSize,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? (widget.selectedColor ??
                                    colors.black.withOpacity(0.8))
                                : colors.black,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check,
                            size: 16,
                            color: widget.selectedColor ??
                                colors.black.withOpacity(0.8)),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
    );
  }
}

class FilterOption<T> {
  final String label;
  final T value;

  const FilterOption({
    required this.label,
    required this.value,
  });
}
