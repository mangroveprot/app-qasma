import 'package:flutter/material.dart';
import '../../theme/theme_extensions.dart'; // assuming this contains context.colors, .weight, .radii

class CustomInputField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;
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
          children: [
            if (icon != null) ...[
              Icon(icon, color: colors.textPrimary.withOpacity(0.6), size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: fontWeight.medium,
                      color: colors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: controller,
                    enabled: isEnabled,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: fontWeight.medium,
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
