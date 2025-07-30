import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/theme_extensions.dart';
import '../../../utils/form_field_config.dart';
import '../../bloc/form/form_cubit.dart';
import '../../custom_form_field.dart';
import '../../modal.dart';
import '../../models/modal_option.dart';
import 'confirmation_button.dart';
import 'enhanced_radio_card.dart';

class AnimatedRadioContent<T> extends StatefulWidget {
  final List<ModalOption> options;
  final String title;
  final String? subtitle;
  final String confirmButtonText;
  final String cancelButtonText;
  final String othersPlaceholder;
  final Future<T> Function(String selectedReason)? onConfirm;

  const AnimatedRadioContent({
    super.key,
    required this.options,
    required this.title,
    this.subtitle,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.othersPlaceholder = 'Please specify...',
    this.onConfirm,
  });

  @override
  State<AnimatedRadioContent<T>> createState() =>
      _AnimatedRadioContentState<T>();
}

class _AnimatedRadioContentState<T> extends State<AnimatedRadioContent<T>> {
  String? _selectedValue;
  final TextEditingController _othersController = TextEditingController();
  final FocusNode _othersFocusNode = FocusNode();

  @override
  void dispose() {
    _othersController.dispose();
    _othersFocusNode.dispose();
    super.dispose();
  }

  void _handleOptionTap(ModalOption option) {
    setState(() {
      _selectedValue = option.value;
    });

    // Focus on text field if "Others" is selected
    if (option.requiresInput) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _othersFocusNode.requestFocus();
      });
    } else {
      // Clear others text if different option is selected
      _othersController.clear();
    }
  }

  Future<void> _handleConfirm() async {
    if (_selectedValue == null) return;

    final selectedOption = widget.options.firstWhere(
      (option) => option.value == _selectedValue,
    );

    String result;

    if (selectedOption.requiresInput && _othersController.text.isNotEmpty) {
      result = _othersController.text;
    } else {
      result = selectedOption.subtitle ?? selectedOption.title;
    }

    if (widget.onConfirm != null) {
      await widget.onConfirm!(result);
    }

    if (mounted) Navigator.pop(context, result);
  }

  bool get _canConfirm {
    final formCubit = context.read<FormCubit>();
    debugPrint('Checking if can confirm');

    if (_selectedValue == null) return false;

    print({'_selectedValue', _selectedValue});

    final isValid = formCubit.validateAll({
      field_other_option.field_key: _othersController.text,
    });

    if (!isValid) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: ModalUI.header(
              widget.title,
              subtitle: widget.subtitle,
              onClose: () => Navigator.pop(context),
            ),
          ),

          // Content
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

                  // Others text field (show when others is selected)
                  if (_selectedValue != null &&
                      widget.options.any((opt) =>
                          opt.value == _selectedValue && opt.requiresInput))
                    _buildOthersTextField(context),

                  const SizedBox(height: 30),

                  ConfirmationButton(
                      onPressed: _handleConfirm,
                      labelText: widget.confirmButtonText),
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
      child: Row(
        children: [
          RepaintBoundary(
            child: CustomFormField(
                field_key: field_other_option.field_key,
                name: field_other_option.name,
                controller: _othersController,
                hint: field_other_option.hint),
          ),
        ],
      ),
    );
  }
}
