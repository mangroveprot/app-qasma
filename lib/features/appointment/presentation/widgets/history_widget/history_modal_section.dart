import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_modal/custom_modal.dart';

class HistoryModalSection {
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    String? title,
  }) {
    return CustomModal.simpleShow(
      context: context,
      title: title,
      child: child,
    );
  }
}
