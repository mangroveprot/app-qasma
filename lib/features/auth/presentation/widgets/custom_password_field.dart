import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/helpers/spacing.dart';
import '../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../theme/theme_extensions.dart';

class PasswordValidationRule {
  final String rule;
  final bool isValid;
  final RegExp regex;

  PasswordValidationRule({
    required this.rule,
    required this.isValid,
    required this.regex,
  });
}

class CustomPasswordField extends StatefulWidget {
  final String field_key;
  final String name;
  final TextEditingController controller;
  final String hint;
  final bool showPasswordRule;
  final bool required;
  final bool showErrorText;
  final String? customErrorMessage;
  final Iterable<String>? autofillHints;

  const CustomPasswordField({
    super.key,
    required this.field_key,
    required this.name,
    required this.controller,
    required this.hint,
    this.showPasswordRule = true,
    this.required = false,
    this.showErrorText = true,
    this.customErrorMessage,
    this.autofillHints = const [AutofillHints.password],
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _isPasswordVisible = false;
  List<PasswordValidationRule> _validationRules = [];

  @override
  void initState() {
    super.initState();
    _initializeValidationRules();
    widget.controller.addListener(_validatePassword);
  }

  void _initializeValidationRules() {
    _validationRules = [
      PasswordValidationRule(
        rule: '6-20 characters',
        isValid: false,
        regex: RegExp(r'^.{6,20}$'),
      ),
      PasswordValidationRule(
        rule: 'At least one letter',
        isValid: false,
        regex: RegExp(r'[a-zA-Z]'),
      ),
      PasswordValidationRule(
        rule: "Don't use : , \" / \\",
        isValid: false,
        regex: RegExp(r'^[^:,"\/\\]*$'),
      ),
      PasswordValidationRule(
        rule: 'No spaces',
        isValid: false,
        regex: RegExp(r'^\S*$'),
      ),
    ];
  }

  void _validatePassword() {
    final password = widget.controller.text;
    setState(() {
      for (int i = 0; i < _validationRules.length; i++) {
        _validationRules[i] = PasswordValidationRule(
          rule: _validationRules[i].rule,
          isValid: _validationRules[i].regex.hasMatch(password),
          regex: _validationRules[i].regex,
        );
      }
    });
  }

  bool get isPasswordValid {
    return _validationRules.every((rule) => rule.isValid);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePassword);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = context.select<FormCubit, bool>((cubit) {
      final state = cubit.state;
      return state.hasError(widget.field_key);
    });

    final errorMessage = context.select<FormCubit, String?>((cubit) {
      final state = cubit.state;
      return state.getErrorMessage(widget.field_key);
    });

    final radiusMedium = context.radii.medium;
    final primaryColor = context.colors.primary;
    final textColor = context.colors.textPrimary;
    final dangerColor = context.colors.error;
    final weightRegular = context.weight.regular;
    final midGroundColor = context.colors.surface;
    final weightMedium = context.weight.medium;
    final double size = 16;
    final colors = context.colors;

    // error message to show
    final String displayErrorMessage =
        errorMessage ?? widget.customErrorMessage ?? 'This field is required';

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
                      color: dangerColor,
                      fontSize: 12,
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
                color: hasError ? dangerColor : midGroundColor,
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: !_isPasswordVisible,
              autofillHints: widget.autofillHints,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'^\s|\s$')),
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size,
                  vertical: size,
                ),
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: weightRegular,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: textColor.withOpacity(0.6),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
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
                color: colors.black,
                fontSize: size,
                fontWeight: weightRegular,
              ),
            ),
          ),
          if (hasError && widget.showErrorText)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                displayErrorMessage,
                style: TextStyle(
                  color: dangerColor,
                  fontSize: 12,
                  fontWeight: weightRegular,
                ),
              ),
            ),
          if (widget.controller.text.isNotEmpty && widget.showPasswordRule)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: _validationRules
                    .map(
                      (rule) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              rule.isValid ? Icons.check_circle : Icons.cancel,
                              color: rule.isValid ? primaryColor : dangerColor,
                              size: 18,
                            ),
                            Spacing.horizontalXSmall,
                            Expanded(
                              child: Text(
                                rule.rule,
                                style: TextStyle(
                                  color:
                                      rule.isValid ? primaryColor : dangerColor,
                                  fontSize: 12,
                                  fontWeight: weightRegular,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

extension CustomPasswordFieldValidation on CustomPasswordField {
  static bool isValid(String password) {
    final rules = [
      RegExp(r'^.{6,20}$'), // 6-20 characters
      RegExp(r'[a-zA-Z]'), // At least one letter
      RegExp(r'^[^:,"\/\\]*$'), // No forbidden characters
      RegExp(r'^\S*$'), // No spaces
    ];

    return rules.every((rule) => rule.hasMatch(password));
  }
}
