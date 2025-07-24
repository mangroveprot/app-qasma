// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../theme/theme_extensions.dart';

// Individual OTP Field Component
class OtplFields extends StatefulWidget {
  final String fieldKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  final VoidCallback onSubmitted;

  const OtplFields({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    required this.onSubmitted,
  });

  @override
  State<OtplFields> createState() => _OtplFieldsState();
}

class _OtplFieldsState extends State<OtplFields> {
  late final Color textPrimary;
  late final Color colorDanger;
  late final FontWeight weightMedium;

  bool _lastHasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache theme values once
    textPrimary = context.colors.textPrimary;
    colorDanger = context.colors.error;
    weightMedium = context.weight.medium;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 50,
      child: BlocSelector<FormCubit, FormValidationState, bool>(
        selector: (state) => state.hasError(widget.fieldKey),
        builder: (context, hasError) {
          final hasStateChanged = hasError != _lastHasError;

          if (hasStateChanged) {
            _lastHasError = hasError;
          }

          return TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              fontSize: 18,
              fontWeight: weightMedium,
              color: textPrimary,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? colorDanger : textPrimary,
                  width: 1,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? colorDanger : textPrimary,
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? colorDanger : textPrimary,
                  width: 2,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorDanger, width: 1),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorDanger, width: 2),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (value) {
              widget.onChanged(value);
              if (value.isEmpty) {
                widget.onBackspace();
              }
            },
            onSubmitted: (_) => widget.onSubmitted(),
            onTap: () {
              // select all text when tapped
              if (widget.controller.text.isNotEmpty) {
                widget.controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: widget.controller.text.length,
                );
              }
            },
          );
        },
      ),
    );
  }
}
