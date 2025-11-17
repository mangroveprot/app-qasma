import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart';

class CustomInputField extends StatefulWidget {
  final String fieldName;
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool isEnabled;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    required this.fieldName,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.icon,
    this.isEnabled = true,
    this.keyboardType,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
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
                color: colors.textPrimary.withOpacity(0.6),
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
                    child: TextFormField(
                      controller: widget.controller,
                      enabled: widget.isEnabled,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: fontWeight.medium,
                        color: widget.isEnabled
                            ? colors.black
                            : colors.black.withOpacity(0.5),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.controller.text.isEmpty
                            ? 'Not provided'
                            : null,
                        hintStyle: TextStyle(
                          color: colors.textPrimary.withOpacity(0.4),
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                        ),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onChanged: (_) => widget.onChanged(),
                      keyboardType: widget.keyboardType,
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
