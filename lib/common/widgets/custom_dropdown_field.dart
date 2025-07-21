import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_extensions.dart';
import 'bloc/form/form_cubit.dart';

class CustomDropdownField extends StatelessWidget {
  final String name;
  final String field_key;
  final ValueNotifier<String?> controller;
  final List<String> items;
  final String hint;
  final bool required;
  final bool showErrorText;

  const CustomDropdownField({
    super.key,
    required this.field_key,
    required this.name,
    required this.controller,
    required this.hint,
    required this.items,
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
    final midGroundColor = context.colors.surface;
    final weightRegular = context.weight.regular;
    final weightMedium = context.weight.medium;
    final double size = 16;

    return Flexible(
      child: ValueListenableBuilder<String?>(
        valueListenable: controller,
        builder: (context, value, _) {
          return Column(
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
                          color: colorDanger,
                          fontSize: 14,
                          fontWeight: weightMedium,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: midGroundColor,
                  borderRadius: radiusMedium,
                  border: Border.all(
                    color: hasError ? colorDanger : midGroundColor,
                    width: 1.0,
                  ),
                ),
                child: DropdownButtonFormField<String?>(
                  value: value,
                  isExpanded: true,
                  onChanged: (newValue) => controller.value = newValue,
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
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: textColor,
                    size: 24,
                  ),
                  dropdownColor: Colors.white,
                  elevation: 8,
                  borderRadius: radiusMedium,
                  items:
                      items
                          .map(
                            (item) => DropdownMenuItem<String?>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: size,
                                  fontWeight: weightRegular,
                                ),
                              ),
                            ),
                          )
                          .toList(),
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
          );
        },
      ),
    );
  }
}
