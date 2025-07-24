import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/field_state.dart';
import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../theme/theme_extensions.dart';
import '_otp_field.dart';

class OtpBuildFieldsSection extends StatefulWidget {
  final String fieldKey;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(int, String) onChanged;
  final Function(int) onBackspace;
  final Function(int) onSubmitted;
  final bool showErrorText;
  final String? customErrorMessage;

  const OtpBuildFieldsSection({
    super.key,
    required this.fieldKey,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.onBackspace,
    required this.onSubmitted,
    this.showErrorText = true,
    this.customErrorMessage,
  });

  @override
  State<OtpBuildFieldsSection> createState() => _OtpBuildFieldsSectionState();
}

class _OtpBuildFieldsSectionState extends State<OtpBuildFieldsSection> {
  late final Color colorDanger;
  late final FontWeight weightRegular;
  late final List<Widget> otpFields;

  bool _lastHasError = false;
  String? _lastErrorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorDanger = context.colors.error;
    weightRegular = context.weight.regular;

    // Pre-build OTP fields to avoid rebuilding on every render
    otpFields = List.generate(6, (index) {
      return OtplFields(
        fieldKey: '${widget.fieldKey}_field_$index',
        controller: widget.controllers[index],
        focusNode: widget.focusNodes[index],
        onChanged: (value) => widget.onChanged(index, value),
        onBackspace: () => widget.onBackspace(index),
        onSubmitted: () => widget.onSubmitted(index),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FormCubit, FormValidationState, FieldState>(
      selector: (state) {
        final hasError = state.hasError(widget.fieldKey);
        final errorMessage = state.getErrorMessage(widget.fieldKey);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: otpFields,
              ),
            ),
            if (fieldState.hasError && widget.showErrorText)
              _buildErrorText(fieldState.errorMessage),
          ],
        );
      },
    );
  }

  Widget _buildErrorText(String? errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        errorMessage ??
            widget.customErrorMessage ??
            'Please enter a valid OTP code',
        style: TextStyle(
          color: colorDanger,
          fontSize: 12,
          fontWeight: weightRegular,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
