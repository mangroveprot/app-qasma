import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/category_type_model.dart';
import 'category_type_field.dart';

class CategoryTypeItem extends StatelessWidget {
  final String category;
  final int index;
  final CategoryTypeModel model;
  final Function(String, int, String, int) onUpdate;
  final Function(String, int) onRemove;

  const CategoryTypeItem({
    super.key,
    required this.category,
    required this.index,
    required this.model,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: CategoryTypeField(
              label: 'Type',
              initialValue: model.type,
              hintText: 'Enter type name',
              onChanged: (value) =>
                  onUpdate(category, index, value, model.duration),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: CategoryTypeField(
              label: 'Duration',
              initialValue: model.duration.toString(),
              hintText: '30',
              keyboardType: TextInputType.number,
              suffixText: 'min',
              onChanged: (value) {
                final duration = int.tryParse(value) ?? 30;
                onUpdate(category, index, model.type, duration);
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            child: IconButton(
              onPressed: () => onRemove(category, index),
              icon: Icon(Icons.delete_outline, color: colors.error, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: colors.error.withOpacity(0.1),
                foregroundColor: colors.error,
                padding: const EdgeInsets.all(12),
                minimumSize: const Size(48, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
