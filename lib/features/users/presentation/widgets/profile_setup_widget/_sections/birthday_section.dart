import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/utils/constant.dart';
import '../../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../../infrastructure/theme/theme_extensions.dart';

class BirthdateSection extends StatelessWidget {
  final String fieldKey;
  final ValueNotifier<String?> monthController;
  final ValueNotifier<String?> dayController;
  final ValueNotifier<String?> yearController;
  final bool required;
  final bool showErrorText;
  final String? customErrorMessage;

  const BirthdateSection({
    super.key,
    required this.fieldKey,
    required this.monthController,
    required this.dayController,
    required this.yearController,
    this.required = false,
    this.showErrorText = true,
    this.customErrorMessage,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    DateTime tempDate = DateTime(now.year - 18, now.month, now.day);

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        monthController.value = monthsList[tempDate.month - 1];
                        dayController.value = tempDate.day.toString();
                        yearController.value = tempDate.year.toString();
                        context.read<FormCubit>().clearFieldError(fieldKey);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: tempDate,
                    minimumDate: DateTime(1900),
                    maximumDate: now,
                    onDateTimeChanged: (DateTime newDate) {
                      tempDate = newDate;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final hasError = context.select<FormCubit, bool>((cubit) {
      final state = cubit.state;
      return state.hasError(fieldKey);
    });

    final errorMessage = context.select<FormCubit, String?>((cubit) {
      final state = cubit.state;
      return state.getErrorMessage(fieldKey);
    });

    final String displayErrorMessage =
        errorMessage ?? customErrorMessage ?? 'This field is required';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Birthdate',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 14,
              fontWeight: context.weight.medium,
            ),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: colors.error),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<String?>(
          valueListenable: monthController,
          builder: (_, month, __) => ValueListenableBuilder<String?>(
            valueListenable: dayController,
            builder: (_, day, __) => ValueListenableBuilder<String?>(
              valueListenable: yearController,
              builder: (_, year, __) {
                final hasDate = month != null && day != null && year != null;
                final displayText =
                    hasDate ? '$month $day, $year' : 'Select a date';

                return GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasError ? colors.error : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayText,
                            style: TextStyle(
                              fontSize: 14,
                              color: hasDate
                                  ? colors.black
                                  : colors.textPrimary.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: colors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (hasError && showErrorText)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              displayErrorMessage,
              style: TextStyle(
                color: colors.error,
                fontSize: 12,
                fontWeight: context.weight.regular,
              ),
            ),
          ),
      ],
    );
  }
}
