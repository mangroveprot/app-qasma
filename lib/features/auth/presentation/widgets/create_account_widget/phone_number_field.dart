import 'package:flutter/material.dart';
import '../../../../../theme/theme_extensions.dart';

class PhoneNumberField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool required;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (label.isNotEmpty)
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 14,
                fontWeight: context.weight.medium,
              ),
              children: required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: colors.error),
                      ),
                    ]
                  : [],
            ),
          ),
        const SizedBox(height: 8),

        // TextField with flag and prefix
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              fontSize: 14,
              color: colors.black,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: colors.textPrimary,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🇵🇭',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+63',
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
