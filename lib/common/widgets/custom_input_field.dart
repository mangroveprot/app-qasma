import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String? value;
  final Future<void> Function(String) onChanged;
  final String placeholder;

  const CustomInputField({
    Key? key,
    required this.label,
    this.value,
    required this.onChanged,
    this.placeholder = 'Not Set',
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late final TextEditingController _controller;
  bool _isEditing = false;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    final initialValue = widget.value ?? '';
    _controller.text = initialValue;
  }

  @override
  void didUpdateWidget(CustomInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Always update the controller text when the widget value changes
    // but only if we're not currently editing
    if (oldWidget.value != widget.value) {
      final newValue = widget.value ?? '';
      if (!_isEditing) {
        _controller.text = newValue;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _hasError = false;
    });

    final currentValue = widget.value ?? '';
    _controller.text = currentValue;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  Future<void> _saveEdit() async {
    final newValue = _controller.text;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await widget.onChanged(newValue);

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      // Force update the controller text to the saved value after editing is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isEditing) {
          final latestValue = widget.value ?? '';
          _controller.text = latestValue;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _hasError = false;
    });
    final originalValue = widget.value ?? '';
    _controller.text = originalValue;
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = widget.value ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 1),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // Input field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Value/TextField
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _saveEdit(),
                      )
                    : Text(
                        displayValue.isEmpty
                            ? widget.placeholder
                            : displayValue,
                        style: TextStyle(
                          fontSize: 17,
                          color: displayValue.isEmpty
                              ? Colors.grey.shade500
                              : Colors.black,
                        ),
                      ),
              ),

              const SizedBox(width: 8),

              // Action Icons
              if (_isEditing) ...[
                // Cancel button
                GestureDetector(
                  onTap: _cancelEdit,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Save button
                GestureDetector(
                  onTap: _isLoading ? null : _saveEdit,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          )
                        : Icon(
                            Icons.check,
                            size: 18,
                            color: _hasError
                                ? Colors.red.shade600
                                : Colors.green.shade600,
                          ),
                  ),
                ),
              ] else
                // Edit button
                GestureDetector(
                  onTap: _startEditing,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
