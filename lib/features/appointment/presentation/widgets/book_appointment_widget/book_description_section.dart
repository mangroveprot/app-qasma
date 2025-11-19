import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/form_field_config.dart';
import '../../../../../common/utils/tooltips_items.dart';
import '../../../../../common/widgets/bloc/form/form_cubit.dart';
import '../../../../../infrastructure/theme/theme_extensions.dart';
import 'book_type_label.dart';

class BookDescriptionSection extends StatelessWidget {
  final Map<String, TextEditingController> textControllers;

  const BookDescriptionSection({
    super.key,
    required this.textControllers,
  });

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
          text: ToolTip.description.key,
          tooltip: ToolTip.description.tips,
        ),
        const SizedBox(height: 16),
        BlocSelector<FormCubit, FormValidationState, bool>(
          selector: (state) => state.hasError(field_description.field_key),
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
                      width: hasError ? 1.0 : 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      maxLines: null,
                      controller: textControllers[field_description.field_key],
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          context
                              .read<FormCubit>()
                              .clearFieldError(field_description.field_key);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: field_description.hint,
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
