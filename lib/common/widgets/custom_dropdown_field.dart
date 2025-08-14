// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_extensions.dart';
import '../utils/field_state.dart';
import 'bloc/form/form_cubit.dart';

class CustomDropdownField extends StatefulWidget {
  final String field_key;
  final String? name;
  final ValueNotifier<String?> controller;
  final List<String> items;
  final String hint;
  final bool required;
  final bool showErrorText;
  final String? customErrorMessage;

  const CustomDropdownField({
    super.key,
    required this.field_key,
    this.name,
    required this.controller,
    required this.hint,
    required this.items,
    this.showErrorText = true,
    this.required = false,
    this.customErrorMessage,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  late final BorderRadius radiusMedium;
  late final Color colorDanger;
  late final Color textColor;
  late final FontWeight weightRegular;
  late final Color midGroundColor;
  late final FontWeight weightMedium;
  late final List<DropdownMenuItem<String?>> dropdownItems;

  bool _lastHasError = false;
  String? _lastErrorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // cache theme values once
    radiusMedium = context.radii.medium;
    colorDanger = context.colors.error;
    textColor = context.colors.textPrimary;
    weightRegular = context.weight.regular;
    midGroundColor = context.colors.surface;
    weightMedium = context.weight.medium;

    dropdownItems = widget.items
        .map(
          (item) => DropdownMenuItem<String?>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: weightRegular,
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.name != null) _buildLabel(),
          BlocSelector<FormCubit, FormValidationState, FieldState>(
            selector: (state) {
              final hasError = state.hasError(widget.field_key);
              final errorMessage = state.getErrorMessage(widget.field_key);
              return FieldState(hasError: hasError, errorMessage: errorMessage);
            },
            builder: (context, fieldState) {
              final hasStateChanged = fieldState.hasError != _lastHasError ||
                  fieldState.errorMessage != _lastErrorMessage;

              if (hasStateChanged) {
                _lastHasError = fieldState.hasError;
                _lastErrorMessage = fieldState.errorMessage;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField(fieldState.hasError),
                  if (fieldState.hasError && widget.showErrorText)
                    _buildErrorText(fieldState.errorMessage),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Text(
            widget.name!,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: weightMedium,
            ),
          ),
          if (widget.required)
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
    );
  }

  Widget _buildDropdownField(bool hasError) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: radiusMedium,
            border: Border.all(
              color: hasError ? colorDanger : midGroundColor,
              width: 1.0,
            ),
          ),
          child: DropdownButtonFormField<String?>(
            value: value,
            isExpanded: true,
            onChanged: (newValue) => widget.controller.value = newValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.all(16),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 16,
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
                borderSide: BorderSide(
                  color:
                      hasError ? colorDanger : Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: radiusMedium,
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: radiusMedium,
                borderSide: BorderSide(color: colorDanger, width: 2.0),
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
            items: dropdownItems,
            selectedItemBuilder: (BuildContext context) {
              return widget.items.map<Widget>((String item) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: weightRegular,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorText(String? errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        errorMessage ?? widget.customErrorMessage ?? 'This field is required',
        style: TextStyle(
          color: colorDanger,
          fontSize: 12,
          fontWeight: weightRegular,
        ),
      ),
    );
  }
}
