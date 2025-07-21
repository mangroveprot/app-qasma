import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_extensions.dart';
import 'bloc/form/form_cubit.dart';

class CustomFormField extends StatelessWidget {
  final String field_key;
  final String name;
  final TextEditingController controller;
  final String hint;
  final bool required;
  final bool showErrorText;

  const CustomFormField({
    super.key,
    required this.field_key,
    required this.name,
    required this.controller,
    required this.hint,
    this.showErrorText = true,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = context.select<FormCubit, bool>((cubit) {
      final state = cubit.state;
      return state.hasError(field_key);
    });

    final radiusMedium = context.radii.medium;
    final colorDanger = context.colors.error;
    final textColor = context.colors.textPrimary;
    final dangerColor = context.colors.error;
    final weightRegular = context.weight.regular;
    final midGroundColor = context.colors.surface;
    final weightMedium = context.weight.medium;
    final double size = 16;

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: weightMedium,
                  ),
                ),
                if (required)
                  Text(
                    ' *',
                    style: TextStyle(
                      color: dangerColor,
                      fontSize: 14,
                      fontWeight: weightMedium,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: radiusMedium,
              border: Border.all(
                color: hasError ? colorDanger : midGroundColor,
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size,
                  vertical: size,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  color: textColor,
                  fontSize: size,
                  fontWeight: weightRegular,
                ),
                border: OutlineInputBorder(
                  borderRadius: radiusMedium,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: radiusMedium,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: radiusMedium,
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: radiusMedium,
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: radiusMedium,
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                color: textColor,
                fontSize: size,
                fontWeight: weightRegular,
              ),
            ),
          ),
          if (hasError && required && showErrorText)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                'This field is required',
                style: TextStyle(
                  color: colorDanger,
                  fontSize: 12,
                  fontWeight: weightRegular,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
