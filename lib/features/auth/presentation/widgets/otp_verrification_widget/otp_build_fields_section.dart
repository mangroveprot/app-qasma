import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../theme/theme_extensions.dart';

class OtpBuildFieldsSection extends StatefulWidget {
  final String fieldKey;
  final Function(int, String) onChanged;
  final Function(int) onBackspace;
  final Function(int) onSubmitted;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpBuildFieldsSection({
    super.key,
    required this.fieldKey,
    required this.onChanged,
    required this.onBackspace,
    required this.onSubmitted,
    required this.controllers,
    required this.focusNodes,
  });

  @override
  State<OtpBuildFieldsSection> createState() => _OtpBuildFieldsSectionState();
}

class _OtpBuildFieldsSectionState extends State<OtpBuildFieldsSection> {
  static const int _otpLength = 6;

  late final TextEditingController _hiddenController;
  late final FocusNode _hiddenFocusNode;

  int _currentBoxIndex = 0;
  String _previousOtpValue = '';

  @override
  void initState() {
    super.initState();
    _hiddenController = TextEditingController();
    _hiddenFocusNode = FocusNode()..addListener(_handleFocusChange);
    _initializeFromExistingControllers();
  }

  @override
  void dispose() {
    _hiddenFocusNode.removeListener(_handleFocusChange);
    _hiddenController.dispose();
    _hiddenFocusNode.dispose();
    super.dispose();
  }

  void _initializeFromExistingControllers() {
    final existingOtp = widget.controllers.map((c) => c.text).join();
    if (existingOtp.isNotEmpty) {
      _hiddenController.text = existingOtp;
      _previousOtpValue = existingOtp;
      _currentBoxIndex = existingOtp.length.clamp(0, _otpLength);
    }
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  void _handleBoxTap(int index) {
    _hiddenFocusNode.requestFocus();

    setState(() {
      _currentBoxIndex = index;
    });

    final currentLength = _hiddenController.text.length;
    final cursorPos = index.clamp(0, currentLength);

    _hiddenController.selection = TextSelection.collapsed(offset: cursorPos);
  }

  void _updateDisplayBoxes(String otpValue) {
    for (int i = 0; i < _otpLength; i++) {
      widget.controllers[i].text = i < otpValue.length ? otpValue[i] : '';
    }
  }

  void _clearOtpErrors() {
    final formCubit = context.read<FormCubit>();
    formCubit.clearFieldError(widget.fieldKey);
    for (int i = 0; i < _otpLength; i++) {
      formCubit.clearFieldError('otp_field_$i');
    }
  }

  void _handleOtpChange(String value) {
    String sanitizedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (sanitizedValue.length > _otpLength) {
      sanitizedValue = sanitizedValue.substring(0, _otpLength);
    }

    final isDeletion = sanitizedValue.length < _previousOtpValue.length;
    final isAddition = sanitizedValue.length > _previousOtpValue.length;

    if (isDeletion) {
      _handleDeletion(sanitizedValue);
    } else if (isAddition) {
      _handleAddition(sanitizedValue);
    } else if (sanitizedValue.length == _previousOtpValue.length &&
        sanitizedValue != _previousOtpValue) {
      _handleReplacement(sanitizedValue);
    }
  }

  void _handleDeletion(String newValue) {
    int deletedIndex = 0;
    for (int i = 0; i < _previousOtpValue.length; i++) {
      if (i >= newValue.length ||
          (i < newValue.length && _previousOtpValue[i] != newValue[i])) {
        deletedIndex = i;
        break;
      }
    }

    _updateDisplayBoxes(newValue);

    _hiddenController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: deletedIndex),
    );

    setState(() {
      _currentBoxIndex = deletedIndex;
      _previousOtpValue = newValue;
    });

    widget.onBackspace(deletedIndex);
    _clearOtpErrors();
  }

  void _handleAddition(String newValue) {
    int addedIndex = 0;
    for (int i = 0; i < newValue.length; i++) {
      if (i >= _previousOtpValue.length ||
          newValue[i] != _previousOtpValue[i]) {
        addedIndex = i;
        break;
      }
    }

    _updateDisplayBoxes(newValue);

    final nextPosition = (addedIndex + 1).clamp(0, newValue.length);

    _hiddenController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: nextPosition),
    );

    setState(() {
      _currentBoxIndex = nextPosition;
      _previousOtpValue = newValue;
    });

    _clearOtpErrors();

    if (addedIndex < newValue.length) {
      widget.onChanged(addedIndex, newValue[addedIndex]);
    }
  }

  void _handleReplacement(String newValue) {
    int replacedIndex = 0;
    for (int i = 0; i < newValue.length; i++) {
      if (newValue[i] != _previousOtpValue[i]) {
        replacedIndex = i;
        break;
      }
    }

    _updateDisplayBoxes(newValue);

    final nextPosition = (replacedIndex + 1).clamp(0, newValue.length);

    _hiddenController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: nextPosition),
    );

    setState(() {
      _currentBoxIndex = nextPosition;
      _previousOtpValue = newValue;
    });

    _clearOtpErrors();

    if (replacedIndex < newValue.length) {
      widget.onChanged(replacedIndex, newValue[replacedIndex]);
    }
  }

  void _handleSubmit(String _) {
    if (_hiddenController.text.length == _otpLength) {
      widget.onSubmitted(_otpLength - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOtpInputStack(),
        _buildErrorMessage(),
      ],
    );
  }

  Widget _buildOtpInputStack() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildVisibleOtpBoxes(),
        _buildHiddenTextField(),
      ],
    );
  }

  Widget _buildVisibleOtpBoxes() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: List.generate(
          _otpLength,
          (index) => _buildOtpBox(index: index),
        ),
      ),
    );
  }

  Widget _buildHiddenTextField() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: IgnorePointer(
        ignoring: true,
        child: SizedBox(
          height: 1,
          child: Opacity(
            opacity: 0.0,
            child: TextField(
              controller: _hiddenController,
              focusNode: _hiddenFocusNode,
              autofocus: true,
              showCursor: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_otpLength),
              ],
              onChanged: _handleOtpChange,
              onSubmitted: _handleSubmit,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox({required int index}) {
    final value = index < _hiddenController.text.length
        ? _hiddenController.text[index]
        : '';
    final hasFocus = _hiddenFocusNode.hasFocus && _currentBoxIndex == index;

    return BlocBuilder<FormCubit, FormValidationState>(
      builder: (context, formState) {
        final hasError = formState.hasError('otp_field_$index') ||
            formState.hasError(widget.fieldKey);

        return GestureDetector(
          onTap: () => _handleBoxTap(index),
          child: Container(
            alignment: Alignment.center,
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _getBoxBorderColor(context, hasError, hasFocus),
                  width: hasFocus ? 2 : 1,
                ),
              ),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: context.weight.medium,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBoxBorderColor(BuildContext context, bool hasError, bool hasFocus) {
    if (hasError) return context.colors.error;
    if (hasFocus) return context.colors.primary;
    return context.colors.textPrimary;
  }

  Widget _buildErrorMessage() {
    return BlocBuilder<FormCubit, FormValidationState>(
      builder: (context, state) {
        final errorMessage = state.getErrorMessage(widget.fieldKey);
        if (errorMessage == null || errorMessage.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            errorMessage,
            style: TextStyle(
              color: context.colors.error,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
