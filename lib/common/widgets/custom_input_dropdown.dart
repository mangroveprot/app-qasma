import 'package:flutter/material.dart';

import '../../infrastructure/theme/theme_extensions.dart';

class CustomInputDropdownField extends StatefulWidget {
  final String fieldName;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final bool isEnabled;

  const CustomInputDropdownField({
    super.key,
    required this.fieldName,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.icon,
    this.iconColor,
    this.isEnabled = true,
  });

  @override
  State<CustomInputDropdownField> createState() =>
      _CustomInputDropdownFieldState();
}

class _CustomInputDropdownFieldState extends State<CustomInputDropdownField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
    final radius = context.radii;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: radius.medium,
        border: Border.all(
          color:
              _isFocused ? colors.textPrimary : colors.black.withOpacity(0.25),
          width: _isFocused ? 2 : 1.5,
        ),
        color: colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.iconColor ?? colors.textPrimary.withOpacity(0.6),
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: fontWeight.medium,
                      color: colors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() => _isFocused = hasFocus);
                    },
                    child: DropdownButtonFormField<String>(
                      value: widget.value.isEmpty ? null : widget.value,
                      isExpanded: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: fontWeight.medium,
                        color: widget.isEnabled
                            ? colors.black
                            : colors.black.withOpacity(0.5),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        hintText: 'Select ${widget.label}',
                        hintStyle: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: colors.textPrimary,
                      ),
                      items: widget.options.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return widget.options.map<Widget>((String item) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final textPainter = TextPainter(
                                  text: TextSpan(
                                    text: item,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: fontWeight.medium,
                                    ),
                                  ),
                                  textDirection: TextDirection.ltr,
                                );
                                textPainter.layout();

                                // Only apply fade if text is longer than available space
                                final needsFade = textPainter.width >
                                    constraints.maxWidth - 20;

                                if (needsFade) {
                                  return ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Colors.black,
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                        stops: [0.0, 0.8, 1.0],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: Text(
                                      item,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: fontWeight.medium,
                                        color: widget.isEnabled
                                            ? colors.black
                                            : colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    item,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: fontWeight.medium,
                                      color: widget.isEnabled
                                          ? colors.black
                                          : colors.black.withOpacity(0.5),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }).toList();
                      },
                      onChanged: widget.isEnabled
                          ? (newValue) => widget.onChanged(newValue ?? '')
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
