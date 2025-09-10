import 'package:flutter/material.dart';
import '../../infrastructure/theme/theme_extensions.dart'; // assuming this contains context.colors, .weight, .radii

class CustomInputField extends StatelessWidget {
  final String fieldName;
  final String? label;
  final double? fontSize;
  final FontWeight? fontWeight;
  final IconData? icon;
  final Color? iconColor;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool isEnabled;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool expands;

  const CustomInputField({
    super.key,
    required this.fieldName,
    this.label,
    this.fontSize,
    this.fontWeight,
    required this.controller,
    required this.onChanged,
    this.iconColor,
    this.icon,
    this.isEnabled = true,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customFontWeight = context.weight;
    final radius = context.radii;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: radius.medium,
        border: Border.all(
          color: colors.white.withOpacity(0.4),
          width: 1,
        ),
        color: colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Changed to start for multi-line alignment
          children: [
            if (icon != null) ...[
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor?.withOpacity(0.1)) ?? Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon,
                      color: iconColor ?? colors.textPrimary, size: 20)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) ...[
                    Text(
                      label!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: customFontWeight.medium,
                        color: colors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  TextFormField(
                    controller: controller,
                    enabled: isEnabled,
                    maxLines: maxLines,
                    minLines: minLines,
                    expands: expands,
                    style: TextStyle(
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? customFontWeight.medium,
                      color: isEnabled
                          ? colors.black
                          : colors.black.withOpacity(0.5),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      //  hintText: 'Enter $label',
                      hintStyle: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: (_) => onChanged(),
                    keyboardType: keyboardType,
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
