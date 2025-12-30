import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../theme/theme_extensions.dart';

class PhoneNumberField extends StatelessWidget {
  final String fieldKey;
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool required;
  final bool showErrorText;
  final String? customErrorMessage;

  const PhoneNumberField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.controller,
    this.required = false,
    this.showErrorText = true,
    this.customErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final hasError = context.select<FormCubit, bool>((cubit) {
      final state = cubit.state;
      return state.hasError(fieldKey);
    });

    final errorMessage = context.select<FormCubit, String?>((cubit) {
      final state = cubit.state;
      return state.getErrorMessage(fieldKey);
    });

    final String displayErrorMessage =
        errorMessage ?? customErrorMessage ?? 'This field is required';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? colors.error : Colors.grey.shade300,
            ),
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
                color: colors.textPrimary.withOpacity(0.5),
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
        if (hasError && showErrorText)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              displayErrorMessage,
              style: TextStyle(
                color: colors.error,
                fontSize: 12,
                fontWeight: context.weight.regular,
              ),
            ),
          ),
      ],
    );
  }
}
