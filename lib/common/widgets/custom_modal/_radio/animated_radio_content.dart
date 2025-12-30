import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/button/button_cubit.dart';
import '../../modal.dart';
import '../../models/modal_option.dart';
import '../../toast/app_toast.dart';
import 'confirmation_button.dart';
import 'enhanced_radio_card.dart';

enum SelectedOptionType {
  value,
  title,
  subtitle,
}

class AnimatedRadioContent<T> extends StatefulWidget {
  final List<ModalOption> options;
  final String title;
  final String? subtitle;
  final String confirmButtonText;
  final String cancelButtonText;
  final String othersPlaceholder;
  final Future<T> Function(String selectedReason)? onConfirm;
  final SelectedOptionType selectedOptionType;
  final String? buttonId;

  const AnimatedRadioContent({
    super.key,
    required this.options,
    required this.title,
    this.subtitle,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.othersPlaceholder = 'Please specify...',
    this.onConfirm,
    required this.selectedOptionType,
    this.buttonId,
  });

  @override
  State<AnimatedRadioContent<T>> createState() =>
      _AnimatedRadioContentState<T>();
}

class _AnimatedRadioContentState<T> extends State<AnimatedRadioContent<T>> {
  String? _selectedValue;
  final TextEditingController _othersController = TextEditingController();
  final FocusNode _othersFocusNode = FocusNode();
  bool _hasOthersError = false;

  ModalOption? _cachedSelectedOption;

  @override
  void dispose() {
    _othersController.dispose();
    _othersFocusNode.dispose();
    super.dispose();
  }

  void _handleOptionTap(ModalOption option) {
    // Prevent unnecessary rebuilds if same option selected
    if (_selectedValue == option.value) return;

    setState(() {
      _selectedValue = option.value;
      _cachedSelectedOption = option; // Cache to avoid lookup
      _hasOthersError = false; // Clear error when option changes
    });

    if (option.requiresInput) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _othersFocusNode.requestFocus();
      });
    } else {
      _othersController.clear();
    }
  }

  String _getSelectedOptionValue(ModalOption option) {
    switch (widget.selectedOptionType) {
      case SelectedOptionType.value:
        return option.value;
      case SelectedOptionType.title:
        return option.title;
      case SelectedOptionType.subtitle:
        return option.subtitle ??
            option.title; // Fallback to title if subtitle is null
    }
  }

  Future<void> _handleConfirm() async {
    if (_selectedValue == null) return;

    final selectedOption = _cachedSelectedOption ??
        widget.options.firstWhere((option) => option.value == _selectedValue);

    if (selectedOption.requiresInput) {
      final othersText = _othersController.text.trim();

      if (othersText.isEmpty) {
        setState(() {
          _hasOthersError = true;
        });

        _othersFocusNode.requestFocus();

        AppToast.show(
            message: 'Please specify the reason', type: ToastType.error);
        return;
      }

      // Additional validation: minimum length
      if (othersText.length < 3) {
        setState(() {
          _hasOthersError = true;
        });

        _othersFocusNode.requestFocus();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Please provide more details (at least 3 characters)'),
            backgroundColor: Colors.red[600],
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    String result;

    if (selectedOption.requiresInput && _othersController.text.isNotEmpty) {
      result = _othersController.text.trim();
    } else {
      result = _getSelectedOptionValue(selectedOption);
    }

    if (widget.onConfirm != null) {
      await widget.onConfirm!(result);
    }

    if (mounted) Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonCubit(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: ModalUI.header(
              widget.title,
              subtitle: widget.subtitle,
              onClose: () => Navigator.pop(context),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAnimatedOptionsList(context),
                  if (_selectedValue != null &&
                      (_cachedSelectedOption?.requiresInput == true))
                    _buildOthersTextField(context),
                  const SizedBox(height: 30),
                  ConfirmationButton(
                    buttonId: widget.buttonId,
                    onPressedAsync: _handleConfirm,
                    labelText: widget.confirmButtonText,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOptionsList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + (index * 100)),
          curve: Curves.easeOut,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, animationValue, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * animationValue),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 400 + (index * 100)),
                opacity: animationValue,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: index < widget.options.length - 1 ? 12 : 0,
                  ),
                  child: EnhancedRadioCard(
                    option: option,
                    isSelected: _selectedValue == option.value,
                    onTap: () => _handleOptionTap(option),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildOthersTextField(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hasOthersError ? Colors.red : Colors.grey.withOpacity(0.3),
          ),
          color: Colors.white,
        ),
        child: TextField(
          controller: _othersController,
          focusNode: _othersFocusNode,
          maxLines: 4,
          minLines: 3,
          decoration: InputDecoration(
            hintText: widget.othersPlaceholder,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
            hintStyle: TextStyle(color: Colors.grey[500]),
            errorText: _hasOthersError ? 'Please specify the reason' : null,
          ),
          onChanged: (value) {
            if (_hasOthersError && value.trim().isNotEmpty) {
              setState(() {
                _hasOthersError = false;
              });
            }
          },
        ),
      ),
    );
  }
}
