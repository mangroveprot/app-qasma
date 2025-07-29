import 'package:flutter/material.dart';

import '../button_text/custom_text_button.dart';
import '../modal.dart';
import '../models/modal_option.dart';

/// Optimized multi selection content using ValueNotifier
class MultiSelectionContent extends StatelessWidget {
  const MultiSelectionContent({
    super.key,
    required this.options,
    required this.title,
    this.subtitle,
    this.selectedValues = const [],
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.maxSelections,
    this.minSelections,
  });

  final List<ModalOption> options;
  final String title;
  final String? subtitle;
  final List<String> selectedValues;
  final String confirmText;
  final String cancelText;
  final int? maxSelections;
  final int? minSelections;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<String>> selectedNotifier =
        ValueNotifier<List<String>>(List.from(selectedValues));

    return ValueListenableBuilder<List<String>>(
      valueListenable: selectedNotifier,
      builder: (context, currentSelections, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalUI.header(title, subtitle: subtitle),
            const SizedBox(height: 16),
            ...options.map((option) => CheckboxListTile(
                  title: Text(option.title),
                  subtitle:
                      option.subtitle != null ? Text(option.subtitle!) : null,
                  value: currentSelections.contains(option.value),
                  onChanged: (checked) {
                    final newSelections = List<String>.from(currentSelections);
                    if (checked == true) {
                      if (maxSelections == null ||
                          newSelections.length < maxSelections!) {
                        newSelections.add(option.value);
                      }
                    } else {
                      newSelections.remove(option.value);
                    }
                    selectedNotifier.value = newSelections;
                  },
                )),
            const SizedBox(height: 16),
            ModalUI.actions([
              CustomTextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: cancelText),
              ModalUI.primaryButton(
                text: confirmText,
                onPressed: currentSelections.length >= (minSelections ?? 0)
                    ? () => Navigator.of(context).pop(currentSelections)
                    : () {},
              )
            ]),
          ],
        );
      },
    );
  }
}
