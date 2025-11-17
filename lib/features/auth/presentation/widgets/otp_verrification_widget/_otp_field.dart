import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../theme/theme_extensions.dart';

class OtplFields extends StatefulWidget {
  final String fieldKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  final VoidCallback onSubmitted;
  final ValueChanged<String>? onPaste;
  final ValueChanged<String>? onSmartInput;
  final bool Function()? areAllFieldsFilled;

  const OtplFields({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    required this.onSubmitted,
    this.onPaste,
    this.onSmartInput,
    this.areAllFieldsFilled,
  });

  @override
  State<OtplFields> createState() => _OtplFieldsState();
}

class _OtplFieldsState extends State<OtplFields> {
  late final Color textPrimary;
  late final Color colorDanger;
  late final FontWeight weightMedium;
  bool _lastHasError = false;

  String previousValue = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textPrimary = context.colors.textPrimary;
    colorDanger = context.colors.error;
    weightMedium = context.weight.medium;
  }

  @override
  void dispose() {
    super.dispose();
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
            ],
            onChanged: (value) async {
              final onlyDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
              final allFilled = widget.areAllFieldsFilled == null
                  ? false
                  : widget.areAllFieldsFilled!();

              if (onlyDigits.isEmpty && previousValue.isNotEmpty) {
                widget.controller.clear();
                widget.onBackspace();
                previousValue = onlyDigits;
                return;
              }

              if (allFilled && onlyDigits.length > 1) {
                final lastChar = onlyDigits.substring(onlyDigits.length - 1);
                widget.controller.value = TextEditingValue(
                  text: lastChar,
                  selection: const TextSelection.collapsed(offset: 1),
                );
                widget.onChanged(lastChar);
                previousValue = lastChar;
                return;
              }

              if (onlyDigits.length > 1) {
                if (widget.onSmartInput != null) {
                  widget.onSmartInput!(onlyDigits);
                  widget.controller.value = TextEditingValue(
                    text: onlyDigits[0],
                    selection: const TextSelection.collapsed(offset: 1),
                  );
                  previousValue = onlyDigits[0];
                }
                return;
              }
              if (onlyDigits.length == 1) {
                widget.controller.value = TextEditingValue(
                  text: onlyDigits[0],
                  selection: const TextSelection.collapsed(offset: 1),
                );
                widget.onChanged(onlyDigits[0]);
                previousValue = onlyDigits[0];
                return;
              }
              if (onlyDigits.isEmpty) {
                widget.controller.clear();
                previousValue = '';
              }
            },
            onSubmitted: (_) => widget.onSubmitted(),
            onTap: () {
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
