// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_extensions.dart';
import '../utils/field_state.dart';
import 'bloc/form/form_cubit.dart';

class CustomFormField extends StatefulWidget {
  final String field_key;
  final String name;
  final TextEditingController controller;
  final String hint;
  final bool required;
  final bool showErrorText;
  final String? customErrorMessage;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

  const CustomFormField({
    super.key,
    required this.field_key,
    required this.name,
    required this.controller,
    required this.hint,
    this.showErrorText = true,
    this.required = false,
    this.customErrorMessage,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late final BorderRadius radiusMedium;
  late final Color colorDanger;
  late final Color textColor;
  late final FontWeight weightRegular;
  late final Color midGroundColor;
  late final FontWeight weightMedium;

  bool _lastHasError = false;
  String? _lastErrorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    radiusMedium = context.radii.medium;
    colorDanger = context.colors.error;
    textColor = context.colors.textPrimary;
    weightRegular = context.weight.regular;
    midGroundColor = context.colors.surface;
    weightMedium = context.weight.medium;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(),
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
                  _buildTextField(fieldState.hasError),
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
            widget.name,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: weightMedium,
            ),
          ),
          if (widget.required)
            Text(
              ' *',
              style: TextStyle(
                color: colorDanger,
                fontSize: 12,
                fontWeight: weightMedium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(bool hasError) {
    final fontWeight = context.weight;
    final colors = context.colors;
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        color: colors.black,
        fontSize: 14,
        fontWeight: fontWeight.regular,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: textColor.withOpacity(0.6),
          fontSize: 14,
          fontWeight: weightRegular,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(
            color: hasError ? colorDanger : midGroundColor,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(
            color: hasError ? colorDanger : midGroundColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(
            color: hasError ? colorDanger : Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide(color: colorDanger, width: 1.0),
        ),
      ),
      autovalidateMode: AutovalidateMode.disabled,
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
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
