import 'package:flutter/material.dart';

class CustomInputDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> options;
  final Future<void> Function(String?) onChanged;
  final String placeholder;

  const CustomInputDropdown({
    Key? key,
    required this.label,
    this.value,
    required this.options,
    required this.onChanged,
    this.placeholder = 'Not Set',
  }) : super(key: key);

  @override
  State<CustomInputDropdown> createState() => _CustomInputDropdownState();
}

class _CustomInputDropdownState extends State<CustomInputDropdown> {
  bool _isEditing = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomInputDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update selected value when widget value changes, but only if not editing
    if (oldWidget.value != widget.value && !_isEditing) {
      _selectedValue = widget.value;
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _hasError = false;
      _selectedValue = widget.value;
    });
  }

  Future<void> _saveEdit() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await widget.onChanged(_selectedValue);

      setState(() {
        _isEditing = false;
        _isLoading = false;
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
      _selectedValue = widget.value;
    });
  }

  void _selectOption(String? value) {
    setState(() {
      _selectedValue = value;
    });
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

        // Dropdown field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Value/Dropdown
              Expanded(
                child: _isEditing
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: DropdownButton<String>(
                          value: widget.options.contains(_selectedValue)
                              ? _selectedValue
                              : null,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          hint: Text(
                            widget.placeholder,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          items: widget.options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: _selectOption,
                        ),
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
