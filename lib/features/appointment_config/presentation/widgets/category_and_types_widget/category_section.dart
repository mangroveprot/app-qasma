import 'package:flutter/material.dart';

import '../../../../../infrastructure/theme/theme_extensions.dart';
import '../../../data/models/category_type_model.dart';
import 'category_options_menu.dart';
import 'category_type_item.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final List<CategoryTypeModel> types;
  final Function(String) onAddType;
  final Function(String) onDeleteCategory;
  final Function(String, int, String, int) onUpdateType;
  final Function(String, int) onRemoveType;

  const CategorySection({
    super.key,
    required this.category,
    required this.types,
    required this.onAddType,
    required this.onDeleteCategory,
    required this.onUpdateType,
    required this.onRemoveType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fontWeight = context.weight;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colors, fontWeight),
            const SizedBox(height: 20),
            ...types.asMap().entries.map((entry) => CategoryTypeItem(
                  category: category,
                  index: entry.key,
                  model: entry.value,
                  onUpdate: onUpdateType,
                  onRemove: onRemoveType,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic colors, dynamic fontWeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 18,
              fontWeight: fontWeight.medium,
              color: colors.textPrimary,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => onAddType(category),
              icon: Icon(Icons.add, color: colors.secondary, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: colors.secondary.withOpacity(0.1),
                minimumSize: const Size(32, 32),
                padding: const EdgeInsets.all(4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            // const SizedBox(width: 6),
            CategoryOptionsMenu(
              category: category,
              onDeleteCategory: onDeleteCategory,
            ),
          ],
        ),
      ],
    );
  }
}
