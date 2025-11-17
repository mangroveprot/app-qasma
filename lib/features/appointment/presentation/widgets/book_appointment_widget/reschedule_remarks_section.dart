import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/utils/tooltips_items.dart';
import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import 'book_type_label.dart';

class RescheduleRemarksSection extends StatefulWidget {
  final Map<String, TextEditingController> textControllers;

  const RescheduleRemarksSection({
    super.key,
    required this.textControllers,
  });

  @override
  State<RescheduleRemarksSection> createState() =>
      _RescheduleRemarksSectionState();
}

class _RescheduleRemarksSectionState extends State<RescheduleRemarksSection> {
  @override
  void initState() {
    super.initState();
    final controller = widget.textControllers[field_remarks.field_key]!;
    if (controller.text == 'null' || controller.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final weight = context.weight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BookTypeLabel(
          text: ToolTip.remarks.key,
          tooltip: ToolTip.remarks.tips,
        ),
        const SizedBox(height: 16),
        BlocSelector<FormCubit, FormValidationState, bool>(
          selector: (state) => state.hasError(field_remarks.field_key),
          builder: (context, hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colors.white.withOpacity(0.8),
                    borderRadius: radii.small,
                    border: Border.all(
                      color: hasError
                          ? colors.error
                          : colors.accent.withOpacity(0.4),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      maxLines: null,
                      controller:
                          widget.textControllers[field_remarks.field_key],
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          context
                              .read<FormCubit>()
                              .clearFieldError(field_remarks.field_key);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: field_remarks.hint,
                        hintStyle: TextStyle(
                          color: colors.textPrimary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.black,
                      ),
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      'This field is required',
                      style: TextStyle(
                        color: colors.error,
                        fontSize: 12,
                        fontWeight: weight.regular,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
