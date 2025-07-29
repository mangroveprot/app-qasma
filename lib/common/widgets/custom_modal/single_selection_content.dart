import 'package:flutter/material.dart';

import '../modal.dart';
import '../models/modal_option.dart';

class SingleSelectionContent extends StatelessWidget {
  const SingleSelectionContent({
    super.key,
    required this.options,
    required this.title,
    this.subtitle,
    this.selectedValue,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
  });

  final List<ModalOption> options;
  final String title;
  final String? subtitle;
  final String? selectedValue;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String?> selectedNotifier =
        ValueNotifier<String?>(selectedValue);

    return ValueListenableBuilder<String?>(
      valueListenable: selectedNotifier,
      builder: (context, currentSelection, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalUI.header(title, subtitle: subtitle),
            const SizedBox(height: 16),
            ...options.map((option) => RadioListTile<String>(
                  title: Text(option.title),
                  subtitle:
                      option.subtitle != null ? Text(option.subtitle!) : null,
                  value: option.value,
                  groupValue: currentSelection,
                  onChanged: (value) => selectedNotifier.value = value,
                )),
            const SizedBox(height: 16),
            ModalUI.actions([
              ModalUI.secondaryButton(
                  text: cancelText,
                  onPressed: () => Navigator.of(context).pop()),
              ModalUI.primaryButton(
                  text: confirmText,
                  onPressed: () => Navigator.of(context).pop(currentSelection))
            ]),
          ],
        );
      },
    );
  }
}
