import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';

class CategoryTypeField extends StatelessWidget {
  final String label;
  final String initialValue;
  final String hintText;
  final TextInputType? keyboardType;
  final String? suffixText;
  final Function(String) onChanged;

  const CategoryTypeField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
    this.keyboardType,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: _inputDecoration(colors, hintText, suffixText),
          style: const TextStyle(fontSize: 16),
          onChanged: onChanged,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
      dynamic colors, String hint, String? suffix) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.textPrimary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.textPrimary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.textPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: colors.white,
      suffixText: suffix,
      suffixStyle: suffix != null
          ? TextStyle(color: colors.textPrimary, fontSize: 14)
          : null,
    );
  }
}
